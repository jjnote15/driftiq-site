import SwiftUI

/// Once-per-day bonus with an escalating 7-day streak. Watching a (mock)
/// rewarded ad doubles the payout.
struct DailyRewardView: View {
    let reward: DailyReward
    @EnvironmentObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss
    @State private var showAd = false

    var body: some View {
        ZStack {
            Theme.bgTop.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("🎁").font(.system(size: 56))
                Text(L.t("daily.title")).font(.title.bold())
                HStack(spacing: 6) {
                    ForEach(1...7, id: \.self) { day in
                        Text("\(day)")
                            .font(.caption.bold())
                            .frame(width: 32, height: 32)
                            .background(
                                Circle().fill(day <= reward.day
                                              ? Theme.sunOrange
                                              : Color.white.opacity(0.08))
                            )
                            .foregroundStyle(day <= reward.day ? .black : Theme.textDim)
                    }
                }
                Text(String(format: L.t("daily.day.format"), reward.day))
                    .font(.headline)
                    .foregroundStyle(Theme.sunYellow)
                if reward.grantsBoost {
                    Text(L.t("daily.boost.note"))
                        .font(.footnote)
                        .foregroundStyle(Theme.sunYellow)
                }
                Button {
                    engine.claimDaily(doubled: false)
                    Haptics.success()
                    dismiss()
                } label: {
                    Text(String(format: L.t("daily.claim.format"), Fmt.money(reward.money)))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.sunOrange)
                Button {
                    showAd = true
                } label: {
                    Label(String(format: L.t("daily.double.format"), Fmt.money(reward.money * 2)),
                          systemImage: "play.rectangle.fill")
                        .font(.subheadline.bold())
                }
                .foregroundStyle(Theme.sunYellow)
                Text(L.t("daily.streak.info"))
                    .font(.footnote)
                    .foregroundStyle(Theme.textDim)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .foregroundStyle(.white)
        }
        .fullScreenCover(isPresented: $showAd) {
            MockRewardedAdView {
                engine.claimDaily(doubled: true)
                dismiss()
            }
        }
        .presentationDetents([.medium, .large])
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled()
    }
}
