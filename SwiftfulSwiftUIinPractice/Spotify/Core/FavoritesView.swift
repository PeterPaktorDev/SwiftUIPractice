//
//  FavoritesView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/22.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var playerManager = MusicPlayerManager.shared
    @State private var favorites: [FavoriteMedia] = []
    @State private var showOptionsMenu: Bool = false
    @State private var selectedMedia: MediaItem? = nil
    
    var body: some View {
        ZStack{
            Color.spotifyBlack.ignoresSafeArea()
            
            VStack {
                if favorites.isEmpty {
                    Text("No favorite songs available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(favorites, id: \.id) { favorite in
                                let media = favorite.media
                                SongRowCell(
                                    media: media,
                                    imageSize: 50,
                                    imageName: media.artworkUrl60?.absoluteString ?? "",
                                    title: media.trackName ?? "",
                                    subtitle: media.artistName,
                                    onCellPressed: {
                                        playerManager.playTrack(media)
                                    },
                                    onEllipsisPressed: {
                                        selectedMedia = media.deepCopy()
                                        showOptionsMenu = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    
                    if let media = selectedMedia, showOptionsMenu {
                        Color.black.opacity(0.5).ignoresSafeArea()
                            .onTapGesture {
                                showOptionsMenu = false
                            }
                        
                        OptionsMenuView(
                            media: media,
                            onAddToLikedSongs: {
                                if media.isFavorite(context: modelContext) {
                                    FavoritesManager.shared.removeFromFavorites(media.deepCopy(), context: modelContext)
                                } else {
                                    FavoritesManager.shared.addToFavorites(media.deepCopy(), context: modelContext)
                                }
                                showOptionsMenu = false
                            },
                            onAddToPlaylist: {
                                // Add to playlist action
                                showOptionsMenu = false
                            },
                            onHideSong: {
                                // Hide song action
                                showOptionsMenu = false
                            },
                            onAddToQueue: {
                                // Add to queue action
                                showOptionsMenu = false
                            },
                            onShare: {
                                // Share action
                                showOptionsMenu = false
                            },
                            onStartJam: {
                                // Start a jam action
                                showOptionsMenu = false
                            },
                            onGoToRadio: {
                                // Go to radio action
                                showOptionsMenu = false
                            },
                            onDismiss: {
                                showOptionsMenu = false
                            }
                        )
                        .environment(\.modelContext, modelContext)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10)
                    }
                }
            }
            .onAppear {
                loadFavorites()
            }
            .onChange(of: showOptionsMenu) {
                if !showOptionsMenu {
                    loadFavorites()
                }
            }
        }
    }
    
    private func loadFavorites() {
        favorites = FavoritesManager.shared.getAllFavorites(context: modelContext)
    }
}

#Preview {
    FavoritesView()
}

