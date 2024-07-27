//
//  SpotifyNewReleaseCell.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import SwiftUI

struct SpotifyNewReleaseCell: View {
    @Environment(\.modelContext) private var modelContext
    var media: MediaItem
    var imageName: String = Constants.randomImage
    var headline: String? = "New release from"
    var subheadline: String? = "Some Artist"
    var title: String? = "Some Playlist"
    var subtitle: String? = "Single - title"
    var onAddToPlaylistPressed: (() -> Void)? = nil
    var onPlayPressed: (() -> Void)? = nil

    @State private var isFavorite: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ImageLoaderView(urlString: imageName)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    if let headline {
                        Text(headline)
                            .foregroundStyle(.spotifyLightGray)
                            .font(.callout)
                    }
                    
                    if let subheadline {
                        Text(subheadline)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.spotifyWhite)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ImageLoaderView(urlString: imageName)
                    .frame(width: 140, height: 140)
                
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title {
                            Text(title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.spotifyWhite)
                        }
                        
                        if let subtitle {
                            Text(subtitle)
                                .foregroundStyle(.spotifyLightGray)
                        }
                    }
                    .font(.callout)
                    
                    HStack(spacing: 0) {
                        Image(systemName: isFavorite ? "heart.fill" : "plus.circle")
                            .foregroundStyle(isFavorite ? .spotifyGreen : .spotifyLightGray)
                            .font(.title3)
                            .padding(4)
                            .background(Color.black.opacity(0.001))
                            .onTapGesture {
                                toggleFavorite()
                                onAddToPlaylistPressed?()
                            }
                            .offset(x: -4)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(.spotifyWhite)
                            .font(.title)
                    }
                }
                .padding(.trailing, 16)
            }
            .themeColors(isSelected: false)
            .cornerRadius(8)
            .onTapGesture {
                onPlayPressed?()
            }
        }
        .onAppear {
            isFavorite = FavoritesManager.shared.isFavorite(media, context: modelContext)
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            FavoritesManager.shared.removeFromFavorites(media, context: modelContext)
        } else {
            FavoritesManager.shared.addToFavorites(media, context: modelContext)
        }
        isFavorite.toggle()
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        SpotifyNewReleaseCell(media: MediaItem.mock)
            .padding()
    }
}
