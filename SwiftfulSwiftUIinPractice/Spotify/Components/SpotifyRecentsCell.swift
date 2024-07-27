//
//  SpotifyRecentsCell.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import SwiftUI

struct SpotifyRecentsCell: View {
    @ObservedObject var musicPlayerManager = MusicPlayerManager.shared
    
    var media: MediaItem
    
    var body: some View {
        HStack(spacing: 5) {
            ImageLoaderView(urlString: media.artworkUrl60?.absoluteString ?? "")
                .frame(width: 55, height: 55)
            
            Text(media.trackName ?? "")
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(minWidth: 55, maxWidth: .infinity, alignment: .leading)

            
            if media.id == musicPlayerManager.currentTrack?.id {
                let isPlaying = musicPlayerManager.isPlaying
                if isPlaying {
                    BarAnimationView()
                        .frame(width: 15)
                } else {
                    Image(systemName: "ellipsis")
                        .font(.subheadline)
                        .foregroundStyle(.spotifyGreen)
                        .frame(width: 15)
                }
            }
        }
        .padding(.trailing, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .themeColors(isSelected: false)
        .cornerRadius(6)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            HStack {
                SpotifyRecentsCell(media: MediaItem.mock)
                SpotifyRecentsCell(media: MediaItem.mock)
            }
            HStack {
                SpotifyRecentsCell(media: MediaItem.mock)
                SpotifyRecentsCell(media: MediaItem.mock)
            }
        }
    }
}
