//
//  MusicPlayerManager.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/18.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class MusicPlayerManager: ObservableObject {
    static let shared = MusicPlayerManager()
    
    @Published var hasBeenPlayed: Bool = false
    @Published var isPlaying: Bool = false
    @Published var currentTrack: MediaItem?
    @Published var progress: Double = 0.0
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    
    private init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session configured successfully")
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    func playTrack(_ track: MediaItem) {
        guard let url = track.previewUrl else {
            print("Invalid URL")
            return
        }

        print("Playing track with URL: \(url)")
        
        resetPlayer()

        currentTrack = track
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // 添加时间观察者以更新播放进度
        addPeriodicTimeObserver()

        player?.play()
        isPlaying = true
        hasBeenPlayed = true

        // 监听播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func pauseTrack() {
        player?.pause()
        isPlaying = false
    }
    
    func resumeTrack() {
        if progress == 0, let currentTrack = currentTrack {
            playTrack(currentTrack)
            return
        }
        player?.play()
        isPlaying = true
    }

    @objc private func playerDidFinishPlaying() {
        isPlaying = false
        progress = 0.0
        print("Track finished playing")
    }
    
    private func addPeriodicTimeObserver() {
        // 清除之前的时间观察者
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        // 添加新的时间观察者
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            if let duration = self.playerItem?.duration {
                let currentTime = CMTimeGetSeconds(time)
                let totalTime = CMTimeGetSeconds(duration)
                self.progress = currentTime / totalTime
            }
        }
    }
    
    func seek(to progress: Double) {
        guard let duration = playerItem?.duration else { return }
        let totalTime = CMTimeGetSeconds(duration)
        let newTime = totalTime * progress
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    private func resetPlayer() {
        if let player = player {
            if let timeObserverToken = timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
                self.timeObserverToken = nil
            }
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        player = nil
        playerItem = nil
        isPlaying = false
        progress = 0.0
    }
}
