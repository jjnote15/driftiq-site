import SwiftUI

struct StoreView: View {
    @EnvironmentObject private var engine: GameEngine
    @EnvironmentObject private var store: StoreManager
    @Environment(\.dismiss) private var dismiss

    private var purchased: Bool {
        store.adsRemoved || engine.state.adsRemoved
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgTop.ignoresSafeArea()
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Text("🚫").font(.system(size: 40))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L.t("store.removeads.name")).font(.headline)
                            Text(L.t("store.removeads.desc"))
                                .font(.caption)
                                .foregroundStyle(Theme.textDim)
                        }
                        Spacer()
                    }
                    .card()
                    if purchased {
                        Label(L.t("store.purchased"), systemImage: "checkmark.seal.fill")
                            .font(.headline)
                            .foregroundStyle(Theme.sunYellow)
                    } else if let product = store.removeAdsProduct {
                        Button {
                            Task { await store.purchaseRemoveAds() }
                        } label: {
                            Text("\(L.t("store.removeads.name")) – \(product.displayPrice)")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.sunOrange)
                        .disabled(store.purchaseInProgress)
                    } else {
                        Text(L.t("store.unavailable"))
                            .font(.footnote)
                            .foregroundStyle(Theme.textDim)
                            .multilineTextAlignment(.center)
                    }
                    Button(L.t("store.restore")) {
                        Task { await store.restore() }
                    }
                    .font(.footnote)
                    .foregroundStyle(Theme.sunYellow)
                    Text(L.t("store.note"))
                        .font(.footnote)
                        .foregroundStyle(Theme.textDim)
                        .multilineTextAlignment(.center)
                    #if DEBUG
                    Button(L.t("store.reset"), role: .destructive) {
                        engine.resetAll()
                    }
                    .font(.footnote)
                    #endif
                    Spacer()
                }
                .padding(24)
                .foregroundStyle(.white)
            }
            .navigationTitle(L.t("store.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(L.t("done")) { dismiss() }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
    }
}
