import Foundation
import Combine

/// The game loop. Runs a 10 Hz timer on the main thread; all mutation of
/// `state` happens there, so no locking is needed.
final class GameEngine: ObservableObject {
    @Published private(set) var state: GameState
    @Published var offlineReport: OfflineReport?
    @Published private(set) var now = Date()

    private var timer: AnyCancellable?
    private var lastTick = Date()
    private var ticksSinceSave = 0

    /// Offline progress is capped at 8 hours per absence.
    static let offlineCapSeconds: TimeInterval = 8 * 3600

    init() {
        state = SaveStore.load() ?? GameState()
        let elapsed = Date().timeIntervalSince(state.lastSaved)
        if elapsed > 60 { applyOffline(seconds: elapsed) }
        lastTick = Date()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in self?.tick(date) }
    }

    // MARK: - Derived values

    func level(of id: String) -> Int { state.upgrades[id] ?? 0 }

    var prestigeMultiplier: Double { 1 + 0.3 * Double(state.countriesCompleted) }

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
    var boostMultiplier: Double { isBoostActive ? 2 : 1 }

    private var baseEnergyPerSecond: Double {
        var total = 0.0
        for def in UpgradeCatalog.all {
            if case .energyPerSecond(let amount) = def.effect {
                total += amount * Double(level(of: def.id))
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
                base += amount * Double(level(of: def.id))
            }
        }
        return base * multiplierWithoutBoost * boostMultiplier
    }

    var batteryCapacity: Double {
        var cap = 100.0
        for def in UpgradeCatalog.all {
            if case .batteryCapacity(let amount) = def.effect {
                cap += amount * Double(level(of: def.id))
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
        save()
    }

    // MARK: - Actions

    func tap() {
        state.totalTaps += 1
        state.energy = min(batteryCapacity, state.energy + tapPower)
        if hasAutoSell { sellAll() }
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

    func setAdsRemoved() {
        guard !state.adsRemoved else { return }
        state.adsRemoved = true
        save()
    }

    func resetAll() {
        state = GameState()
        SaveStore.wipe()
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
            return
        }
        produce(dt: dt)
        ticksSinceSave += 1
        if ticksSinceSave >= 300 { save() }
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

    /// Boost time is intentionally not counted while offline — offline income
    /// uses the un-boosted rate, capped at `offlineCapSeconds`.
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
