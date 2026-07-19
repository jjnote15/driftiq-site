import SwiftUI

struct BoostView: View {
    @EnvironmentObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss
    @State private var showAd = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bgTop.ignoresSafeArea()
                VStack(spacing: 18) {
                    Text("⚡️").font(.system(size: 64))
                    Text(L.t("boost.title")).font(.title2.bold())
                    Text(L.t("boost.desc"))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Theme.textDim)
                    if engine.isBoostActive {
                        Text(String(format: L.t("boost.active.remaining"),
                                    Fmt.duration(engine.boostRemaining)))
                            .font(.headline)
                            .monospacedDigit()
                            .foregroundStyle(Theme.sunYellow)
                        Text(L.t("boost.stack.hint"))
                            .font(.footnote)
                            .foregroundStyle(Theme.textDim)
                    }
                    Button {
                        showAd = true
                    } label: {
                        Label(L.t("boost.watch"), systemImage: "play.rectangle.fill")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.sunOrange)
                    Text(L.t("boost.mock.note"))
                        .font(.footnote)
                        .foregroundStyle(Theme.textDim)
                }
                .padding(24)
                .foregroundStyle(.white)
            }
            .navigationTitle(L.t("action.boost"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(L.t("done")) { dismiss() }
            }
        }
        .fullScreenCover(isPresented: $showAd) {
            MockRewardedAdView {
                engine.activateBoost()
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
    }
}

/// Pretend rewarded video ad. Later this whole view is replaced by a real
/// AdMob rewarded ad — the reward callback (`onReward`) stays the same.
struct MockRewardedAdView: View {
    let onReward: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var secondsLeft = 5
    @State private var wiggle = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Theme.bgMid], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                HStack {
                    Text(L.t("ad.label"))
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.yellow))
                    Spacer()
                }
                Spacer()
                Text("🥤☀️")
                    .font(.system(size: 80))
                    .rotationEffect(.degrees(wiggle ? 8 : -8))
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: wiggle)
                Text(L.t("ad.fake.headline"))
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(L.t("ad.fake.body"))
                    .foregroundStyle(Theme.textDim)
                    .multilineTextAlignment(.center)
                Spacer()
                if secondsLeft > 0 {
                    Text(String(format: L.t("ad.reward.in"), secondsLeft))
                        .monospacedDigit()
                        .foregroundStyle(Theme.textDim)
                } else {
                    Button {
                        onReward()
                        Haptics.success()
                        Sound.play(.reward)
                        dismiss()
                    } label: {
                        Text(L.t("ad.claim"))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.sunOrange)
                }
            }
            .padding(24)
            .foregroundStyle(.white)
        }
        .onAppear { wiggle = true }
        .onReceive(timer) { _ in
            if secondsLeft > 0 { secondsLeft -= 1 }
        }
        .interactiveDismissDisabled(secondsLeft > 0)
    }
}
