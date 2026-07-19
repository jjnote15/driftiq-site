import Foundation

/// Localization shorthand. All user-facing text lives in Localizable.xcstrings.
enum L {
    static func t(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}

/// Compact number formatting for idle-game scale values: 950, 12.5 K, 3.1 M...
enum Fmt {
    static func number(_ value: Double) -> String {
        let v = abs(value)
        let sign = value < 0 ? "-" : ""
        let pairs: [(Double, String)] = [(1e15, "Q"), (1e12, "T"), (1e9, "B"), (1e6, "M"), (1e3, "K")]
        for (threshold, suffix) in pairs where v >= threshold {
            let scaled = v / threshold
            let text = scaled >= 100 ? String(format: "%.0f", scaled) : String(format: "%.1f", scaled)
            return sign + text + " " + suffix
        }
        if v >= 100 { return sign + String(format: "%.0f", v) }
        if v.truncatingRemainder(dividingBy: 1) < 0.05 { return sign + String(format: "%.0f", v) }
        return sign + String(format: "%.1f", v)
    }

    static func money(_ value: Double) -> String {
        number(value) + " " + L.t("currency")
    }

    static func duration(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 { return String(format: L.t("duration.hm"), h, m) }
        if m > 0 { return String(format: L.t("duration.ms"), m, s) }
        return String(format: L.t("duration.s"), s)
    }
}
