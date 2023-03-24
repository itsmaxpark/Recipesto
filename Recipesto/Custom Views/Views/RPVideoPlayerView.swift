//
//  RPVideoPlayerView.swift
//  Recipesto
//
//  Created by Max Park on 3/24/23.
//

import UIKit
import AVKit

class RPVideoPlayerView: NiblessView {
    
    var player: AVPlayer = AVPlayer()
    var playerVC = AVPlayerViewController()
    var avPlayerLayer: AVPlayerLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        playerVC.showsPlaybackControls = true
        
        addSubview(playerVC.view)
        playerVC.view.frame = self.bounds
    }

    func setContentUrl(url: NSURL) {
        print("Setting up item: \(url)")
        let item = AVPlayerItem(url: url as URL)
        player.replaceCurrentItem(with: item)
        playerVC.player = player
    }

    func play() {
        if (player.currentItem != nil) {
            print("Starting playback!")
            player.play()
        }
    }

    func pause() {
        player.pause()
    }

    func rewind() {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
    }

    func stop() {
        pause()
        rewind()
    }
    
}
