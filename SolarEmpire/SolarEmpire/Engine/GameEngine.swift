import Foundation
import Combine

/// Result of one tap on the sun. ~5 % of taps are critical and give 10×.
struct TapResult {
    let amount: Double
    let critical: Bool
}

/// The game loop. Runs a 10 Hz timer on the main thread; all mutation of
/// `state` happens there, so no locking is needed.
final class GameEngine: ObservableObject {
    @Published private(set) var state: GameState
    @Published var offlineReport: OfflineReport?
    @Published var pendingDaily: DailyReward?
    @Published private(set) var now = Date()

    // Golden sun event: appears at random, tapping it starts a ×5 frenzy.
    @Published private(set) var goldenSunVisible = false
    @Published private(set) var goldenSunX: Double = 0
    @Published private(set) var goldenSunY: Double = 0

    private var goldenSunExpires = Date.distantPast
    private var nextGoldenSpawn = Date.distantFuture
    private var frenzyExpiry = Date.distantPast

    private var timer: AnyCancellable?
    private var lastTick = Date()
    private var ticksSinceSave = 0
    private var ticksSinceDailyCheck = 0

    /// Offline progress is capped at 8 hours per absence.
    static let offlineCapSeconds: TimeInterval = 8 * 3600
    /// Every 10th level of a flat upgrade doubles that upgrade's output.
    static let milestoneStep = 10
    static let criticalChance = 0.05
    static let criticalFactor = 10.0
    static let frenzyFactor = 5.0
    static let frenzyDuration: TimeInterval = 30

    init() {
        state = SaveStore.load() ?? GameState()
        let elapsed = Date().timeIntervalSince(state.lastSaved)
        if elapsed > 60 { applyOffline(seconds: elapsed) }
        lastTick = Date()
        scheduleGoldenSun(first: true)
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in self?.tick(date) }
    }

    // MARK: - Derived values

    func level(of id: String) -> Int { state.upgrades[id] ?? 0 }

    var prestigeMultiplier: Double { 1 + 0.3 * Double(state.countriesCompleted) }

    /// ×2 for every completed block of 10 levels.
    static func milestoneMultiplier(forLevel level: Int) -> Double {
        pow(2, Double(level / milestoneStep))
    }

    private var multiplierWithoutBoost: Double {
        var m = 1.0
        for def in UpgradeCatalog.all {
            if case .productionBonus(let per) = def.effect {
                m += per * Double(level(of: def.id))
            }
        }
        return m * prestigeMultiplier
    }

    var isBoostActive: Bool { (state.boostExpiry ?? .distantPast) > now }
    var boostRemaining: TimeInterval { max(0, state.boostExpiry?.timeIntervalSince(now) ?? 0) }

    var isFrenzyActive: Bool { frenzyExpiry > now }
    var frenzyRemaining: TimeInterval { max(0, frenzyExpiry.timeIntervalSince(now)) }

    var boostMultiplier: Double {
        (isBoostActive ? 2 : 1) * (isFrenzyActive ? Self.frenzyFactor : 1)
    }

    private var baseEnergyPerSecond: Double {
        var total = 0.0
        for def in UpgradeCatalog.all {
            if case .energyPerSecond(let amount) = def.effect {
                let lvl = level(of: def.id)
                total += amount * Double(lvl) * Self.milestoneMultiplier(forLevel: lvl)
            }
        }
        return total
    }

    var energyPerSecondWithoutBoost: Double { baseEnergyPerSecond * multiplierWithoutBoost }
    var energyPerSecond: Double { energyPerSecondWithoutBoost * boostMultiplier }

    var tapPower: Double {
        var base = 1.0
        for def in UpgradeCatalog.all {
            if case .tapPower(let amount) = def.effect {
                let lvl = level(of: def.id)
                base += amount * Double(lvl) * Self.milestoneMultiplier(forLevel: lvl)
            }
        }
        return base * multiplierWithoutBoost * boostMultiplier
    }

    var batteryCapacity: Double {
        var cap = 100.0
        for def in UpgradeCatalog.all {
            if case .batteryCapacity(let amount) = def.effect {
                let lvl = level(of: def.id)
                cap += amount * Double(lvl) * Self.milestoneMultiplier(forLevel: lvl)
            }
        }
        return cap
    }

    var sellPrice: Double {
        var bonus = 0.0
        for def in UpgradeCatalog.all {
            if case .sellPriceBonus(let per) = def.effect {
                bonus += per * Double(level(of: def.id))
            }
        }
        return 1.0 * (1 + bonus)
    }

    var hasAutoSell: Bool {
        for def in UpgradeCatalog.all {
            if case .autoSell = def.effect, level(of: def.id) > 0 { return true }
        }
        return false
    }

    var moneyPerSecond: Double { hasAutoSell ? energyPerSecond * sellPrice : 0 }

    /// The cheapest upgrade that can still be bought — the "next goal"
    /// shown on the main screen so there is always something to save for.
    var nextGoal: UpgradeDef? {
        UpgradeCatalog.all
            .filter { def in
                if let maxLevel = def.maxLevel, level(of: def.id) >= maxLevel { return false }
                return true
            }
            .min { cost(of: $0) < cost(of: $1) }
    }

    // MARK: - Prestige

    var prestigeThreshold: Double { 1_000_000 * pow(8, Double(state.countriesCompleted)) }
    var canPrestige: Bool { state.totalEarnedRun >= prestigeThreshold }

    func prestige() {
        guard canPrestige else { return }
        state.countriesCompleted += 1
        state.energy = 0
        state.money = 0
        state.totalEarnedRun = 0
        state.upgrades = [:]
        state.boostExpiry = nil
        frenzyExpiry = .distantPast
        save()
    }

    // MARK: - Actions

    @discardableResult
    func tap() -> TapResult {
        state.totalTaps += 1
        let critical = Double.random(in: 0..<1) < Self.criticalChance
        let amount = tapPower * (critical ? Self.criticalFactor : 1)
        state.energy = min(batteryCapacity, state.energy + amount)
        if hasAutoSell { sellAll() }
        return TapResult(amount: amount, critical: critical)
    }

    func sellAll() {
        guard state.energy >= 0.01 else { return }
        earn(state.energy * sellPrice)
        state.energy = 0
    }

    @discardableResult
    func buy(_ def: UpgradeDef) -> Bool {
        let lvl = level(of: def.id)
        if let maxLevel = def.maxLevel, lvl >= maxLevel { return false }
        let price = cost(of: def)
        guard state.money >= price else { return false }
        state.money -= price
        state.upgrades[def.id] = lvl + 1
        save()
        return true
    }

    func cost(of def: UpgradeDef) -> Double {
        def.baseCost * pow(def.costGrowth, Double(level(of: def.id)))
    }

    /// Reward for watching a (mock) rewarded ad: 2x production for 4 hours.
    /// Watching again extends the boost.
    func activateBoost(hours: Double = 4) {
        let from = max(now, state.boostExpiry ?? now)
        state.boostExpiry = from.addingTimeInterval(hours * 3600)
        save()
    }

    // MARK: - Golden sun / frenzy

    func catchGoldenSun() {
        guard goldenSunVisible else { return }
        goldenSunVisible = false
        frenzyExpiry = now.addingTimeInterval(Self.frenzyDuration)
        scheduleGoldenSun(first: false)
    }

    private func scheduleGoldenSun(first: Bool) {
        let delay: TimeInterval = first ? .random(in: 45...90) : .random(in: 120...300)
        nextGoldenSpawn = Date().addingTimeInterval(delay)
    }

    private func updateGoldenSun() {
        if goldenSunVisible {
            if now >= goldenSunExpires {
                goldenSunVisible = false
                scheduleGoldenSun(first: false)
            }
        } else if now >= nextGoldenSpawn && !isFrenzyActive {
            goldenSunX = .random(in: -120...120)
            goldenSunY = .random(in: -200...60)
            goldenSunExpires = now.addingTimeInterval(6)
            goldenSunVisible = true
        }
    }

    // MARK: - Daily bonus

    func checkDailyReward() {
        guard pendingDaily == nil, offlineReport == nil else { return }
        let calendar = Calendar.current
        if let last = state.lastDailyClaim, calendar.isDateInToday(last) { return }
        let streak: Int
        if let last = state.lastDailyClaim, calendar.isDateInYesterday(last) {
            streak = state.dailyStreak + 1
        } else {
            streak = 1
        }
        let day = min(streak, 7)
        let incomePerSecond = max(energyPerSecondWithoutBoost * sellPrice, 0.5)
        let money = max(100, incomePerSecond * 240) * Double(day)
        pendingDaily = DailyReward(day: day, streak: streak, money: money, grantsBoost: day >= 7)
    }

    func claimDaily(doubled: Bool) {
        guard let reward = pendingDaily else { return }
        earn(reward.money * (doubled ? 2 : 1))
        if reward.grantsBoost { activateBoost(hours: 1) }
        state.dailyStreak = reward.streak
        state.lastDailyClaim = now
        pendingDaily = nil
        save()
    }

    // MARK: - Offline

    /// Reward for watching a (mock) rewarded ad on the welcome-back screen.
    func doubleOfflineEarnings(_ report: OfflineReport) {
        if report.money > 0 { earn(report.money) }
        if report.energy > 0 {
            state.energy = min(batteryCapacity, state.energy + report.energy)
        }
        save()
    }

    func setAdsRemoved() {
        guard !state.adsRemoved else { return }
        state.adsRemoved = true
        save()
    }

    func resetAll() {
        state = GameState()
        SaveStore.wipe()
        frenzyExpiry = .distantPast
        goldenSunVisible = false
        scheduleGoldenSun(first: true)
        save()
    }

    func save() {
        state.lastSaved = Date()
        SaveStore.save(state)
        ticksSinceSave = 0
    }

    // MARK: - Loop

    private func tick(_ date: Date) {
        now = date
        let dt = date.timeIntervalSince(lastTick)
        lastTick = date
        guard dt > 0 else { return }
        // A gap longer than a minute means the app was suspended.
        if dt > 60 {
            applyOffline(seconds: dt)
            scheduleGoldenSun(first: true)
            return
        }
        produce(dt: dt)
        updateGoldenSun()
        ticksSinceSave += 1
        if ticksSinceSave >= 300 { save() }
        // Catch the date rolling over to a new day while the app is open.
        ticksSinceDailyCheck += 1
        if ticksSinceDailyCheck >= 600 {
            ticksSinceDailyCheck = 0
            checkDailyReward()
        }
    }

    private func produce(dt: TimeInterval) {
        let produced = energyPerSecond * dt
        state.energy = min(batteryCapacity, state.energy + produced)
        if hasAutoSell, state.energy > 0 {
            earn(state.energy * sellPrice)
            state.energy = 0
        }
    }

    private func earn(_ amount: Double) {
        state.money += amount
        state.totalEarnedRun += amount
        state.lifetimeEarned += amount
    }

    /// Boost/frenzy time is intentionally not counted while offline — offline
    /// income uses the un-boosted rate, capped at `offlineCapSeconds`.
    private func applyOffline(seconds: TimeInterval) {
        let capped = min(seconds, Self.offlineCapSeconds)
        let produced = energyPerSecondWithoutBoost * capped
        var moneyGained = 0.0
        var energyGained = 0.0
        if hasAutoSell {
            moneyGained = (state.energy + produced) * sellPrice
            state.energy = 0
            earn(moneyGained)
        } else {
            let before = state.energy
            state.energy = min(batteryCapacity, state.energy + produced)
            energyGained = state.energy - before
        }
        if moneyGained >= 1 || energyGained >= 1 {
            offlineReport = OfflineReport(seconds: seconds, money: moneyGained, energy: energyGained)
        }
        save()
    }
}
