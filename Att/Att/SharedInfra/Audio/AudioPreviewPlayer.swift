//
//  AudioPreviewPlayer.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import AVFoundation

public protocol AudioPreviewPlayer: AnyObject {
    func play(url: URL)
    func pause()
    func stop()
    var isPlaying: Bool { get }
}

public final class DefaultAudioPreviewPlayer: AudioPreviewPlayer {
    private var player: AVPlayer?
    private var currentURL: URL?

    public init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    public var isPlaying: Bool { player?.timeControlStatus == .playing }

    public func play(url: URL) {
        if currentURL != url {
            currentURL = url
            player = AVPlayer(playerItem: AVPlayerItem(url: url))
        }
        player?.play()
    }

    public func pause() { player?.pause() }

    public func stop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        currentURL = nil
    }
}
