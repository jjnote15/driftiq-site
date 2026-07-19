import SwiftUI

struct UpgradesView: View {
    @EnvironmentObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgTop.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(UpgradeCatalog.all) { def in
                            UpgradeRow(def: def)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(L.t("upgrades.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(L.t("done")) { dismiss() }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct UpgradeRow: View {
    @EnvironmentObject private var engine: GameEngine
    let def: UpgradeDef

    var body: some View {
        let level = engine.level(of: def.id)
        let price = engine.cost(of: def)
        let maxed = def.maxLevel.map { level >= $0 } ?? false
        let affordable = engine.state.money >= price

        HStack(spacing: 12) {
            Text(def.icon).font(.system(size: 30))
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(L.t("upgrade.\(def.id).name"))
                        .font(.subheadline.bold())
                    if level > 0 {
                        Text(String(format: L.t("level.format"), level))
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Theme.sunOrange.opacity(0.3)))
                    }
                }
                Text(L.t("upgrade.\(def.id).desc"))
                    .font(.caption)
                    .foregroundStyle(Theme.textDim)
            }
            Spacer(minLength: 8)
            Button {
                if engine.buy(def) {
                    Haptics.success()
                }
            } label: {
                Text(maxed ? L.t("max.label") : Fmt.money(price))
                    .font(.footnote.bold())
                    .monospacedDigit()
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .tint(affordable && !maxed ? Theme.sunOrange : .gray)
            .disabled(maxed || !affordable)
        }
        .card()
        .foregroundStyle(.white)
    }
}
