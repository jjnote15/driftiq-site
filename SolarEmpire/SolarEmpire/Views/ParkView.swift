import SwiftUI

/// The living solar park: every upgrade you buy shows up here, so the
/// player can watch the empire grow instead of just reading numbers.
struct ParkView: View {
    @EnvironmentObject private var engine: GameEngine

    private static let maxPanelsShown = 18
    private static let maxTrackersShown = 6
    private static let maxBatteriesShown = 4

    var body: some View {
        let panels = engine.level(of: "panel")
        let trackers = engine.level(of: "tracker")
        let batteries = engine.level(of: "battery")
        let hasRobot = engine.level(of: "cleaning") > 0 || engine.hasAutoSell
        let hasAI = engine.level(of: "ai") > 0
        let hasWeather = engine.level(of: "weather") > 0
        let producing = engine.energyPerSecond > 0
        let charge = engine.batteryCapacity > 0
            ? engine.state.energy / engine.batteryCapacity : 0

        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [Color(red: 0.15, green: 0.10, blue: 0.20),
                                              Color(red: 0.09, green: 0.06, blue: 0.13)],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardStroke))
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    Text(Countries.current(engine.state.countriesCompleted).flag)
                        .font(.system(size: 18))
                    if hasWeather { Text("🌤️").font(.system(size: 16)) }
                    if hasAI { AIAntenna() }
                    if hasRobot { PatrolRobot() }
                    Spacer()
                    if batteries > Self.maxBatteriesShown {
                        Text("+\(batteries - Self.maxBatteriesShown)")
                            .font(.caption2.bold()).foregroundStyle(Theme.textDim)
                    }
                    ForEach(0..<min(max(batteries, 1), Self.maxBatteriesShown), id: \.self) { _ in
                        BatteryGauge(charge: charge)
                    }
                }
                if panels == 0 && trackers == 0 {
                    Text(L.t("park.empty"))
                        .font(.caption)
                        .foregroundStyle(Theme.textDim)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                } else {
                    VStack(spacing: 5) {
                        panelRow(range: rowIndices(count: shownUnits(panels, trackers).count, row: 0),
                                 units: shownUnits(panels, trackers), producing: producing)
                        if shownUnits(panels, trackers).count > 9 {
                            panelRow(range: rowIndices(count: shownUnits(panels, trackers).count, row: 1),
                                     units: shownUnits(panels, trackers), producing: producing)
                        }
                    }
                    if panels > Self.maxPanelsShown {
                        Text("+\(panels - Self.maxPanelsShown)")
                            .font(.caption2.bold())
                            .foregroundStyle(Theme.sunYellow)
                    }
                }
            }
            .padding(10)
        }
        .frame(height: 112)
        .animation(.spring(response: 0.45, dampingFraction: 0.6),
                   value: panels + trackers * 100 + batteries * 10000)
    }

    /// One entry per visible unit: false = panel, true = tracker (🌻).
    private func shownUnits(_ panels: Int, _ trackers: Int) -> [Bool] {
        Array(repeating: false, count: min(panels, Self.maxPanelsShown))
            + Array(repeating: true, count: min(trackers, Self.maxTrackersShown))
    }

    private func rowIndices(count: Int, row: Int) -> Range<Int> {
        let perRow = 9
        let start = row * perRow
        return start..<min(start + perRow, count)
    }

    @ViewBuilder
    private func panelRow(range: Range<Int>, units: [Bool], producing: Bool) -> some View {
        HStack(spacing: 5) {
            ForEach(range, id: \.self) { index in
                if units[index] {
                    Text("🌻")
                        .font(.system(size: 14))
                        .transition(.scale.combined(with: .opacity))
                } else {
                    SolarPanelSprite(glowing: producing)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            Spacer(minLength: 0)
        }
    }
}

/// A tiny tilted solar panel with a grid, glowing while producing.
struct SolarPanelSprite: View {
    let glowing: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(LinearGradient(colors: [Theme.sunOrange.opacity(0.9),
                                          Theme.sunYellow.opacity(0.7)],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(Color.black.opacity(0.25)).frame(width: 1)
                    }
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 2).stroke(.white.opacity(0.35), lineWidth: 0.5))
            .frame(width: 22, height: 14)
            .rotation3DEffect(.degrees(35), axis: (x: 1, y: 0, z: 0), perspective: 0.6)
            .shadow(color: Theme.sunYellow.opacity(glowing ? 0.55 : 0), radius: 3)
    }
}

/// Battery that visibly fills with the park's stored energy.
struct BatteryGauge: View {
    let charge: Double

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
            RoundedRectangle(cornerRadius: 2)
                .fill(LinearGradient(colors: [Theme.sunOrange, Theme.sunYellow],
                                     startPoint: .bottom, endPoint: .top))
                .frame(height: max(2, 20 * CGFloat(min(1, charge))))
                .padding(1.5)
                .animation(.linear(duration: 0.2), value: charge)
        }
        .frame(width: 12, height: 22)
    }
}

/// Little maintenance robot that patrols the park.
struct PatrolRobot: View {
    @State private var right = false

    var body: some View {
        Text("🤖")
            .font(.system(size: 15))
            .offset(x: right ? 14 : -2)
            .scaleEffect(x: right ? 1 : -1)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                    right = true
                }
            }
            .frame(width: 30)
    }
}

/// Blinking AI control antenna.
struct AIAntenna: View {
    @State private var on = false

    var body: some View {
        Image(systemName: "antenna.radiowaves.left.and.right")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(on ? Theme.sunYellow : Theme.textDim)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    on = true
                }
            }
    }
}
