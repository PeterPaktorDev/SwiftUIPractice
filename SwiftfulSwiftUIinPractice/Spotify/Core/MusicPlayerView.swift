//
//  MusicPlayerView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/18.
//

import Foundation
import SwiftUI

struct MusicPlayerView: View {
    @ObservedObject var manager = MusicPlayerManager.shared
    @State private var isEditing: Bool = false

    var body: some View {
        if let track = manager.currentTrack {
            VStack(spacing: -5) {
                    HStack {
                        // 专辑封面图片
                        if let artworkUrl = track.artworkUrl100, let url = URL(string: artworkUrl.absoluteString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(8)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(8)
                            }
                        } else {
                            Color.gray
                                .frame(width: 55, height: 55)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading) {
                            Text(track.trackName ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(track.artistName ?? "Unknown Artist")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // 音频设备图标
                        Image(systemName: "airplayaudio")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 3)
                        
                        // 播放/暂停按钮
                        Button(action: {
                            if manager.isPlaying {
                                manager.pauseTrack()
                            } else {
                                manager.resumeTrack()
                            }
                        }) {
                            Image(systemName: manager.isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                        }
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                    
                    // 播放进度条
                    Slider(value: Binding(
                        get: {
                            manager.progress
                        },
                        set: { newValue in
                            manager.progress = newValue
                        }
                    ), in: 0...1, onEditingChanged: { editing in
                        isEditing = editing
                        if !editing {
                            manager.seek(to: manager.progress)
                        }
                    })
                    .accentColor(.white)
                    .padding([.horizontal], 3)
                    .onAppear {
                        let thumbImage = UIImage(systemName: "circle.fill")?.resized(to: CGSize(width: 10, height: 10))?.withTintColor(.white)
                        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
                    }
                }
                .background(Color(red: 74/255, green: 32/255, blue: 32/255))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.bottom, -15)
            }
    }
}

#Preview {
    MusicPlayerView()
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
