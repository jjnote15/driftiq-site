import SwiftUI

/// Warm sunset palette on a dark background.
enum Theme {
    static let bgTop = Color(red: 0.10, green: 0.08, blue: 0.18)
    static let bgMid = Color(red: 0.24, green: 0.10, blue: 0.22)
    static let bgBottom = Color(red: 0.42, green: 0.16, blue: 0.19)
    static let sunOrange = Color(red: 1.00, green: 0.58, blue: 0.25)
    static let sunYellow = Color(red: 1.00, green: 0.80, blue: 0.35)
    static let card = Color.white.opacity(0.07)
    static let cardStroke = Color.white.opacity(0.10)
    static let textDim = Color.white.opacity(0.6)
}

struct SunsetBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Theme.bgTop, Theme.bgMid, Theme.bgBottom],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

extension View {
    func card() -> some View {
        self
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Theme.card))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardStroke))
    }
}
