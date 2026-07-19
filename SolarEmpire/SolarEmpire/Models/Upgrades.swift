import Foundation

struct UpgradeDef: Identifiable {
    enum Effect {
        /// Adds flat energy production per second, per level.
        case energyPerSecond(Double)
        /// Adds flat energy per tap, per level.
        case tapPower(Double)
        /// Adds flat battery capacity, per level.
        case batteryCapacity(Double)
        /// Adds a fraction to the sell price, per level (0.2 = +20 %).
        case sellPriceBonus(Double)
        /// Adds a fraction to all production, per level (0.15 = +15 %).
        case productionBonus(Double)
        /// Sells energy automatically, including while the app is closed.
        case autoSell
    }

    let id: String
    let icon: String
    let baseCost: Double
    let costGrowth: Double
    let maxLevel: Int?
    let effect: Effect
}

enum UpgradeCatalog {
    /// Ordered cheapest to most expensive. Cost for the next level is
    /// baseCost * costGrowth^currentLevel.
    static let all: [UpgradeDef] = [
        UpgradeDef(id: "panel",    icon: "🔆", baseCost: 15,      costGrowth: 1.15, maxLevel: nil, effect: .energyPerSecond(1)),
        UpgradeDef(id: "cells",    icon: "⚡️", baseCost: 40,      costGrowth: 1.5,  maxLevel: nil, effect: .tapPower(1)),
        UpgradeDef(id: "battery",  icon: "🔋", baseCost: 100,     costGrowth: 1.35, maxLevel: nil, effect: .batteryCapacity(150)),
        UpgradeDef(id: "inverter", icon: "🔌", baseCost: 250,     costGrowth: 1.6,  maxLevel: 10,  effect: .sellPriceBonus(0.20)),
        UpgradeDef(id: "tracker",  icon: "🌻", baseCost: 600,     costGrowth: 1.15, maxLevel: nil, effect: .energyPerSecond(8)),
        UpgradeDef(id: "weather",  icon: "🌤️", baseCost: 2000,    costGrowth: 1.7,  maxLevel: 10,  effect: .productionBonus(0.15)),
        UpgradeDef(id: "autosell", icon: "🤖", baseCost: 5000,    costGrowth: 1.0,  maxLevel: 1,   effect: .autoSell),
        UpgradeDef(id: "cleaning", icon: "🧼", baseCost: 15000,   costGrowth: 1.9,  maxLevel: 8,   effect: .productionBonus(0.25)),
        UpgradeDef(id: "ai",       icon: "🧠", baseCost: 50000,   costGrowth: 1.17, maxLevel: nil, effect: .energyPerSecond(75)),
        UpgradeDef(id: "grid",     icon: "🏙️", baseCost: 200000,  costGrowth: 2.2,  maxLevel: 5,   effect: .sellPriceBonus(0.50)),
    ]
}
