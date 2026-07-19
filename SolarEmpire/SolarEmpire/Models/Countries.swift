import Foundation

struct Country: Identifiable {
    let key: String
    let flag: String
    var id: String { key }
    var localizedName: String { NSLocalizedString(key, comment: "") }
}

/// The prestige journey. After the last country the list wraps around,
/// so the game never runs out of places to expand to.
enum Countries {
    static let all: [Country] = [
        Country(key: "country.sweden",    flag: "🇸🇪"),
        Country(key: "country.spain",     flag: "🇪🇸"),
        Country(key: "country.germany",   flag: "🇩🇪"),
        Country(key: "country.usa",       flag: "🇺🇸"),
        Country(key: "country.australia", flag: "🇦🇺"),
        Country(key: "country.india",     flag: "🇮🇳"),
        Country(key: "country.brazil",    flag: "🇧🇷"),
        Country(key: "country.japan",     flag: "🇯🇵"),
        Country(key: "country.morocco",   flag: "🇲🇦"),
        Country(key: "country.kenya",     flag: "🇰🇪"),
    ]

    static func current(_ completed: Int) -> Country { all[completed % all.count] }
    static func next(_ completed: Int) -> Country { all[(completed + 1) % all.count] }
}
