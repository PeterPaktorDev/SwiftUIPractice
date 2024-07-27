//
//  SongRowCell.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/17/24.
//

import SwiftUI

struct SongRowCell: View {
    @ObservedObject var musicPlayerManager = MusicPlayerManager.shared
    @Environment(\.modelContext) private var modelContext
    var media: MediaItem
    var imageSize: CGFloat = 50
    var imageName: String = Constants.randomImage
    var title: String = "Some title goes here"
    var subtitle: String? = "Some artist name"
    var onCellPressed: (() -> Void)? = nil
    var onEllipsisPressed: (() -> Void)? = nil
    
    private var isFavorite: Bool {
        return FavoritesManager.shared.isFavorite(media, context: modelContext)
    }

    var body: some View {
        HStack(spacing: 8) {
            ImageLoaderView(urlString: imageName)
                .frame(width: imageSize, height: imageSize)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 5) {
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
                    
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.spotifyWhite)
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.callout)
                        .foregroundStyle(.spotifyLightGray)
                }
            }
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                if isFavorite {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.spotifyGreen)
                }
                
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundStyle(.spotifyWhite)
                    .padding(16)
                    .background(Color.black.opacity(0.001))
                    .onTapGesture {
                        onEllipsisPressed?()
                    }
            }
        }
        .background(Color.black.opacity(0.001))
        .onTapGesture {
            onCellPressed?()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            SongRowCell(media: MediaItem.mock)
            SongRowCell(media: MediaItem.mock)
            SongRowCell(media: MediaItem.mock)
            SongRowCell(media: MediaItem.mock)
            SongRowCell(media: MediaItem.mock)
            SongRowCell(media: MediaItem.mock)
        }
    }
}
