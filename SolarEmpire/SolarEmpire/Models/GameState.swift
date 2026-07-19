import Foundation

/// Everything that needs to survive an app restart. Saved as JSON on disk.
/// Decoding uses defaults for missing keys so old saves keep working when
/// new fields are added.
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
    var dailyStreak: Int = 0
    var lastDailyClaim: Date? = nil

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        energy = try c.decodeIfPresent(Double.self, forKey: .energy) ?? 0
        money = try c.decodeIfPresent(Double.self, forKey: .money) ?? 0
        totalEarnedRun = try c.decodeIfPresent(Double.self, forKey: .totalEarnedRun) ?? 0
        lifetimeEarned = try c.decodeIfPresent(Double.self, forKey: .lifetimeEarned) ?? 0
        totalTaps = try c.decodeIfPresent(Int.self, forKey: .totalTaps) ?? 0
        upgrades = try c.decodeIfPresent([String: Int].self, forKey: .upgrades) ?? [:]
        countriesCompleted = try c.decodeIfPresent(Int.self, forKey: .countriesCompleted) ?? 0
        boostExpiry = try c.decodeIfPresent(Date.self, forKey: .boostExpiry)
        adsRemoved = try c.decodeIfPresent(Bool.self, forKey: .adsRemoved) ?? false
        lastSaved = try c.decodeIfPresent(Date.self, forKey: .lastSaved) ?? .now
        startedAt = try c.decodeIfPresent(Date.self, forKey: .startedAt) ?? .now
        dailyStreak = try c.decodeIfPresent(Int.self, forKey: .dailyStreak) ?? 0
        lastDailyClaim = try c.decodeIfPresent(Date.self, forKey: .lastDailyClaim)
    }
}

/// Summary of what happened while the app was closed, shown in the
/// "Welcome back" sheet.
struct OfflineReport: Identifiable {
    let id = UUID()
    let seconds: TimeInterval
    let money: Double
    let energy: Double
}

/// Today's daily bonus, shown once per calendar day.
struct DailyReward: Identifiable {
    let id = UUID()
    /// 1...7, capped — decides the size of the reward.
    let day: Int
    /// The actual consecutive-day count to store on claim.
    let streak: Int
    let money: Double
    let grantsBoost: Bool
}
