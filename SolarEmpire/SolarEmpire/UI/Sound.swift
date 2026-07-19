import AVFoundation

/// Tiny sound-effect player. The WAVs are synthesized, bundled with the app,
/// and each effect keeps a small pool of players so rapid taps can overlap.
/// Audio category is .ambient: respects the silent switch and doesn't stop
/// the player's own music.
final class Sound {
    enum Effect: String, CaseIterable {
        case tap, sell, buy, crit, golden, reward
    }

    static let shared = Sound()
    private var pools: [Effect: [AVAudioPlayer]] = [:]

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        for effect in Effect.allCases {
            guard let url = Bundle.main.url(forResource: effect.rawValue,
                                            withExtension: "wav") else { continue }
            let poolSize = effect == .tap ? 4 : 2
            let pool = (0..<poolSize).compactMap { _ in try? AVAudioPlayer(contentsOf: url) }
            pool.forEach { $0.prepareToPlay() }
            pools[effect] = pool
        }
    }

    static func play(_ effect: Effect) {
        guard let pool = shared.pools[effect], !pool.isEmpty else { return }
        let player = pool.first(where: { !$0.isPlaying }) ?? pool[0]
        player.currentTime = 0
        player.play()
    }
}
