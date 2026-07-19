import SwiftUI

/// The big tappable sun with floating "+N" labels. ~5 % of taps are
/// critical (10×) with a bigger label and stronger haptic.
struct TapAreaView: View {
    @EnvironmentObject private var engine: GameEngine
    @State private var floaters: [Floater] = []

    struct Floater: Identifiable {
        let id = UUID()
        let text: String
        let x: CGFloat
        let critical: Bool
    }

    var body: some View {
        ZStack {
            Button {
                tap()
            } label: {
                SunView()
            }
            .buttonStyle(SunButtonStyle())
            ForEach(floaters) { floater in
                FloatingLabel(text: floater.text, critical: floater.critical)
                    .offset(x: floater.x)
            }
            VStack {
                Spacer()
                if engine.state.totalTaps < 10 {
                    Text(L.t("tap.hint"))
                        .font(.footnote)
                        .foregroundStyle(Theme.textDim)
                }
            }
        }
        .frame(height: 230)
    }

    private func tap() {
        let result = engine.tap()
        if result.critical {
            Haptics.success()
            Sound.play(.crit)
        } else {
            Haptics.tap()
            Sound.play(.tap)
        }
        let text = (result.critical ? "×10! " : "+") + Fmt.number(result.amount)
        let floater = Floater(text: text,
                              x: .random(in: -70...70),
                              critical: result.critical)
        floaters.append(floater)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            floaters.removeAll { $0.id == floater.id }
        }
    }
}

struct SunView: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [Theme.sunYellow.opacity(0.5), .clear],
                                     center: .center, startRadius: 18, endRadius: 118))
                .frame(width: 236, height: 236)
                .scaleEffect(pulse ? 1.08 : 0.94)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: pulse)
            Circle()
                .fill(LinearGradient(colors: [Theme.sunYellow, Theme.sunOrange],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 156, height: 156)
                .shadow(color: Theme.sunOrange.opacity(0.6), radius: 26)
            Image(systemName: "sun.max.fill")
                .font(.system(size: 56))
                .foregroundStyle(.white.opacity(0.9))
        }
        .onAppear { pulse = true }
    }
}

struct SunButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct FloatingLabel: View {
    let text: String
    var critical = false
    @State private var risen = false

    var body: some View {
        Text(text)
            .font(critical ? .largeTitle.bold() : .title2.bold())
            .monospacedDigit()
            .foregroundStyle(critical ? Color.white : Theme.sunYellow)
            .shadow(color: critical ? Theme.sunOrange : .black.opacity(0.4),
                    radius: critical ? 8 : 2)
            .scaleEffect(critical && !risen ? 1.4 : 1)
            .offset(y: risen ? -170 : -60)
            .opacity(risen ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: critical ? 1.2 : 0.9)) { risen = true }
            }
            .allowsHitTesting(false)
    }
}

/// The rare golden sun that drifts in — tap it within a few seconds to
/// trigger a ×5 production frenzy.
struct GoldenSunView: View {
    let onCatch: () -> Void
    @State private var wobble = false

    var body: some View {
        Button {
            onCatch()
            Haptics.success()
            Sound.play(.reward)
        } label: {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [.white.opacity(0.9), Theme.sunYellow, .clear],
                                         center: .center, startRadius: 4, endRadius: 44))
                    .frame(width: 88, height: 88)
                Image(systemName: "sparkles")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
            }
            .scaleEffect(wobble ? 1.15 : 0.9)
            .rotationEffect(.degrees(wobble ? 10 : -10))
            .shadow(color: Theme.sunYellow.opacity(0.9), radius: 18)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.45).repeatForever(autoreverses: true)) {
                wobble = true
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}
