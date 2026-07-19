import Foundation

/// Everything that needs to survive an app restart. Saved as JSON on disk.
struct GameState: Codable {
    var energy: Double = 0
    var money: Double = 0
    var totalEarnedRun: Double = 0
    var lifetimeEarned: Double = 0
    var totalTaps: Int = 0
    var upgrades: [String: Int] = [:]
    var countriesCompleted: Int = 0
    var boostExpiry: Date? = nil
    var adsRemoved: Bool = false
    var lastSaved: Date = .now
    var startedAt: Date = .now
}

/// Summary of what happened while the app was closed, shown in the
/// "Welcome back" sheet.
struct OfflineReport: Identifiable {
    let id = UUID()
    let seconds: TimeInterval
    let money: Double
    let energy: Double
}
