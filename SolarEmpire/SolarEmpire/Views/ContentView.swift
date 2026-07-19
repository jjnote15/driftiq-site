import SwiftUI

enum ActiveSheet: String, Identifiable {
    case upgrades, boost, prestige, store
    var id: String { rawValue }
}

struct ContentView: View {
    @EnvironmentObject private var engine: GameEngine
    @EnvironmentObject private var store: StoreManager
    @State private var activeSheet: ActiveSheet?

    private var showBanner: Bool {
        !(store.adsRemoved || engine.state.adsRemoved)
    }

    var body: some View {
        ZStack {
            SunsetBackground()
            VStack(spacing: 12) {
                HeaderView()
                EnergyPanel()
                NextGoalBanner { activeSheet = .upgrades }
                Spacer(minLength: 0)
                TapAreaView()
                Spacer(minLength: 0)
                ActionBar(activeSheet: $activeSheet)
                if showBanner {
                    FakeBanner { activeSheet = .store }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 6)
            if engine.goldenSunVisible {
                GoldenSunView { engine.catchGoldenSun() }
                    .offset(x: engine.goldenSunX, y: engine.goldenSunY)
            }
        }
        .animation(.spring(duration: 0.35), value: engine.goldenSunVisible)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .upgrades: UpgradesView()
            case .boost: BoostView()
            case .prestige: PrestigeView()
            case .store: StoreView()
            }
        }
        .sheet(item: $engine.offlineReport, onDismiss: { engine.checkDailyReward() }) { report in
            WelcomeBackView(report: report)
        }
        .sheet(item: $engine.pendingDaily) { reward in
            DailyRewardView(reward: reward)
        }
        .onAppear { engine.checkDailyReward() }
        .onChange(of: engine.goldenSunVisible) { _, visible in
            if visible { Sound.play(.golden) }
        }
        .onChange(of: store.adsRemoved) { _, removed in
            if removed { engine.setAdsRemoved() }
        }
    }
}

// MARK: - Header

struct HeaderView: View {
    @EnvironmentObject private var engine: GameEngine

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                let country = Countries.current(engine.state.countriesCompleted)
                Text("\(country.flag) \(country.localizedName)")
                    .font(.subheadline.bold())
                    .foregroundStyle(Theme.textDim)
                if engine.state.countriesCompleted > 0 {
                    Text(String(format: L.t("header.prestige.bonus"),
                                Int((engine.prestigeMultiplier - 1) * 100)))
                        .font(.caption.bold())
                        .foregroundStyle(Theme.sunYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Theme.sunOrange.opacity(0.25)))
                }
                Spacer()
                if engine.isFrenzyActive {
                    Text(String(format: L.t("frenzy.chip"), Fmt.duration(engine.frenzyRemaining)))
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white))
                } else if engine.isBoostActive {
                    Text(String(format: L.t("boost.chip"), Fmt.duration(engine.boostRemaining)))
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Theme.sunYellow))
                }
            }
            Text(Fmt.money(engine.state.money))
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .contentTransition(.numericText(value: engine.state.money))
                .animation(.snappy, value: engine.state.money)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            HStack(spacing: 14) {
                Label(String(format: L.t("header.energy.per.sec"), Fmt.number(engine.energyPerSecond)),
                      systemImage: "bolt.fill")
                Label(String(format: L.t("header.sell.price"), Fmt.money(engine.sellPrice)),
                      systemImage: "arrow.left.arrow.right")
                if engine.hasAutoSell {
                    Label(String(format: L.t("header.money.per.sec"), Fmt.money(engine.moneyPerSecond)),
                          systemImage: "arrow.triangle.2.circlepath")
                }
            }
            .font(.caption)
            .foregroundStyle(Theme.textDim)
        }
    }
}

// MARK: - Next goal

/// Always-visible pointer to the cheapest upgrade still to buy — there is
/// always a bar filling up towards "one more purchase".
struct NextGoalBanner: View {
    @EnvironmentObject private var engine: GameEngine
    let onTap: () -> Void

    var body: some View {
        if let goal = engine.nextGoal {
            let price = engine.cost(of: goal)
            let progress = min(1, engine.state.money / price)
            let ready = progress >= 1
            Button(action: onTap) {
                HStack(spacing: 10) {
                    Text(goal.icon)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: L.t(ready ? "goal.ready" : "goal.saving"),
                                    L.t("upgrade.\(goal.id).name")))
                            .font(.caption.bold())
                            .foregroundStyle(ready ? Theme.sunYellow : .white)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.12))
                                Capsule()
                                    .fill(ready ? Theme.sunYellow : Theme.sunOrange)
                                    .frame(width: geo.size.width * CGFloat(progress))
                                    .animation(.linear(duration: 0.1), value: progress)
                            }
                        }
                        .frame(height: 5)
                    }
                    Spacer()
                    Text(Fmt.money(price))
                        .font(.caption.bold())
                        .monospacedDigit()
                        .foregroundStyle(ready ? Theme.sunYellow : Theme.textDim)
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(Theme.textDim)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(Theme.card))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ready ? Theme.sunYellow.opacity(0.6) : Theme.cardStroke)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Energy bar + sell

struct EnergyPanel: View {
    @EnvironmentObject private var engine: GameEngine

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "battery.100percent")
                    .foregroundStyle(Theme.sunYellow)
                EnergyBar(value: engine.state.energy, capacity: engine.batteryCapacity)
                Text("\(Fmt.number(engine.state.energy)) / \(Fmt.number(engine.batteryCapacity))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(Theme.textDim)
            }
            if engine.hasAutoSell {
                Label(L.t("autosell.active"), systemImage: "checkmark.circle.fill")
                    .font(.footnote.bold())
                    .foregroundStyle(Theme.sunYellow)
            } else {
                Button {
                    Haptics.tap()
                    Sound.play(.sell)
                    engine.sellAll()
                } label: {
                    HStack {
                        Text(L.t("sell.button")).bold()
                        Text("+" + Fmt.money(engine.state.energy * engine.sellPrice))
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.sunOrange)
                .disabled(engine.state.energy < 0.5)
                if engine.state.energy >= engine.batteryCapacity - 0.01 {
                    Text(L.t("battery.full"))
                        .font(.caption)
                        .foregroundStyle(Theme.sunYellow)
                }
            }
        }
        .card()
    }
}

struct EnergyBar: View {
    let value: Double
    let capacity: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.1))
                Capsule()
                    .fill(LinearGradient(colors: [Theme.sunOrange, Theme.sunYellow],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * CGFloat(min(1, capacity > 0 ? value / capacity : 0)))
                    .animation(.linear(duration: 0.1), value: value)
            }
        }
        .frame(height: 10)
    }
}

// MARK: - Bottom action bar

struct ActionBar: View {
    @EnvironmentObject private var engine: GameEngine
    @Binding var activeSheet: ActiveSheet?

    var body: some View {
        HStack(spacing: 10) {
            ActionButton(icon: "arrow.up.circle.fill", title: L.t("action.upgrades")) {
                activeSheet = .upgrades
            }
            ActionButton(icon: "play.rectangle.fill", title: L.t("action.boost")) {
                activeSheet = .boost
            }
            ActionButton(icon: "globe.europe.africa.fill", title: L.t("action.prestige"),
                         showBadge: engine.canPrestige) {
                activeSheet = .prestige
            }
            ActionButton(icon: "cart.fill", title: L.t("action.store")) {
                activeSheet = .store
            }
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    var showBadge = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title3)
                Text(title).font(.caption2.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 14).fill(Theme.card))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardStroke))
            .overlay(alignment: .topTrailing) {
                if showBadge {
                    Circle().fill(.red).frame(width: 10, height: 10).offset(x: -6, y: 6)
                }
            }
        }
        .foregroundStyle(.white)
    }
}

// MARK: - Fake ad banner

struct FakeBanner: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text("📢")
                Text(L.t("banner.fake"))
                    .font(.caption2)
                    .foregroundStyle(Theme.textDim)
                Spacer()
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.05)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(Theme.cardStroke)
            )
        }
        .buttonStyle(.plain)
    }
}
