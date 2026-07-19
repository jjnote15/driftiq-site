import SwiftUI

/// Shown after the app has been closed for a while: what the solar park
/// produced or earned in the meantime, with a (mock) rewarded ad that
/// doubles the earnings.
struct WelcomeBackView: View {
    let report: OfflineReport
    @EnvironmentObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss
    @State private var showAd = false
    @State private var doubled = false

    var body: some View {
        ZStack {
            Theme.bgTop.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("🌅").font(.system(size: 64))
                Text(L.t("welcome.title")).font(.title.bold())
                Text(String(format: L.t("welcome.away.format"), Fmt.duration(report.seconds)))
                    .foregroundStyle(Theme.textDim)
                if report.money >= 1 {
                    Text(String(format: L.t("welcome.money.format"),
                                Fmt.money(report.money * (doubled ? 2 : 1))))
                        .font(.title3.bold())
                        .foregroundStyle(Theme.sunYellow)
                        .multilineTextAlignment(.center)
                }
                if report.energy >= 1 {
                    Text(String(format: L.t("welcome.energy.format"),
                                Fmt.number(report.energy * (doubled ? 2 : 1))))
                        .font(.title3.bold())
                        .foregroundStyle(Theme.sunYellow)
                        .multilineTextAlignment(.center)
                }
                if !doubled {
                    Button {
                        showAd = true
                    } label: {
                        Label(L.t("welcome.double"), systemImage: "play.rectangle.fill")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.sunOrange)
                }
                Button {
                    dismiss()
                } label: {
                    Text(L.t("welcome.continue"))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(doubled ? Theme.sunOrange : .gray)
            }
            .padding(24)
            .foregroundStyle(.white)
        }
        .fullScreenCover(isPresented: $showAd) {
            MockRewardedAdView {
                engine.doubleOfflineEarnings(report)
                doubled = true
            }
        }
        .presentationDetents([.medium, .large])
        .preferredColorScheme(.dark)
    }
}
