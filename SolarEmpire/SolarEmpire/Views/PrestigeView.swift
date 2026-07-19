import SwiftUI

struct PrestigeView: View {
    @EnvironmentObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss
    @State private var confirmShown = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgTop.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        let current = Countries.current(engine.state.countriesCompleted)
                        let next = Countries.next(engine.state.countriesCompleted)
                        Text("\(current.flag) → \(next.flag)")
                            .font(.system(size: 56))
                        Text(String(format: L.t("prestige.next.format"), next.localizedName))
                            .font(.headline)
                        Text(L.t("prestige.explain"))
                            .font(.callout)
                            .foregroundStyle(Theme.textDim)
                            .multilineTextAlignment(.center)
                        VStack(spacing: 8) {
                            ProgressView(value: min(1, engine.state.totalEarnedRun / engine.prestigeThreshold))
                                .tint(Theme.sunOrange)
                            Text(String(format: L.t("prestige.goal.format"),
                                        Fmt.money(engine.prestigeThreshold)))
                                .font(.footnote)
                            Text(String(format: L.t("prestige.progress.format"),
                                        Fmt.money(engine.state.totalEarnedRun)))
                                .font(.footnote)
                                .foregroundStyle(Theme.textDim)
                        }
                        .card()
                        Button {
                            confirmShown = true
                        } label: {
                            Text(engine.canPrestige ? L.t("prestige.button") : L.t("prestige.locked"))
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.sunOrange)
                        .disabled(!engine.canPrestige)
                    }
                    .padding(24)
                    .foregroundStyle(.white)
                }
            }
            .navigationTitle(L.t("prestige.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(L.t("done")) { dismiss() }
            }
            .confirmationDialog(
                String(format: L.t("prestige.confirm.title"),
                       Countries.next(engine.state.countriesCompleted).localizedName),
                isPresented: $confirmShown,
                titleVisibility: .visible
            ) {
                Button(L.t("prestige.confirm.action")) {
                    engine.prestige()
                    Haptics.success()
                    dismiss()
                }
                Button(L.t("cancel"), role: .cancel) {}
            }
        }
        .preferredColorScheme(.dark)
    }
}
