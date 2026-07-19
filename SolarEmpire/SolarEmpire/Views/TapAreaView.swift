import SwiftUI

/// The big tappable sun with floating "+N" labels.
struct TapAreaView: View {
    @EnvironmentObject private var engine: GameEngine
    @State private var floaters: [Floater] = []

    struct Floater: Identifiable {
        let id = UUID()
        let text: String
        let x: CGFloat
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
                FloatingLabel(text: floater.text)
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
        .frame(height: 280)
    }

    private func tap() {
        engine.tap()
        Haptics.tap()
        let floater = Floater(text: "+" + Fmt.number(engine.tapPower),
                              x: .random(in: -70...70))
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
                                     center: .center, startRadius: 20, endRadius: 140))
                .frame(width: 280, height: 280)
                .scaleEffect(pulse ? 1.08 : 0.94)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: pulse)
            Circle()
                .fill(LinearGradient(colors: [Theme.sunYellow, Theme.sunOrange],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 180, height: 180)
                .shadow(color: Theme.sunOrange.opacity(0.6), radius: 30)
            Image(systemName: "sun.max.fill")
                .font(.system(size: 64))
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
    @State private var risen = false

    var body: some View {
        Text(text)
            .font(.title2.bold())
            .monospacedDigit()
            .foregroundStyle(Theme.sunYellow)
            .shadow(color: .black.opacity(0.4), radius: 2)
            .offset(y: risen ? -160 : -60)
            .opacity(risen ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 0.9)) { risen = true }
            }
            .allowsHitTesting(false)
    }
}
