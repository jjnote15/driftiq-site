import SwiftUI

/// Shown after the app has been closed for a while: what the solar park
/// produced or earned in the meantime.
struct WelcomeBackView: View {
    let report: OfflineReport
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.bgTop.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("🌅").font(.system(size: 64))
                Text(L.t("welcome.title")).font(.title.bold())
                Text(String(format: L.t("welcome.away.format"), Fmt.duration(report.seconds)))
                    .foregroundStyle(Theme.textDim)
                if report.money >= 1 {
                    Text(String(format: L.t("welcome.money.format"), Fmt.money(report.money)))
                        .font(.title3.bold())
                        .foregroundStyle(Theme.sunYellow)
                        .multilineTextAlignment(.center)
                }
                if report.energy >= 1 {
                    Text(String(format: L.t("welcome.energy.format"), Fmt.number(report.energy)))
                        .font(.title3.bold())
                        .foregroundStyle(Theme.sunYellow)
                        .multilineTextAlignment(.center)
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
                .tint(Theme.sunOrange)
            }
            .padding(24)
            .foregroundStyle(.white)
        }
        .presentationDetents([.medium])
        .preferredColorScheme(.dark)
    }
}
