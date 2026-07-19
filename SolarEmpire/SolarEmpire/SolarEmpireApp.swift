import SwiftUI

@main
struct SolarEmpireApp: App {
    @StateObject private var engine = GameEngine()
    @StateObject private var store = StoreManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(engine)
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { _, phase in
            // Save whenever the app leaves the foreground, so offline income
            // can be calculated from an up-to-date timestamp.
            if phase == .background || phase == .inactive {
                engine.save()
            }
        }
    }
}
