//
//  SpotifyPlaylistView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/17/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct SpotifyPlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    @Environment(\.router) var router
    var media: MediaItem = .mock
    var user: User = .mock
    
    @State private var medias: [MediaItem] = []
    @State private var showHeader: Bool = true
    @State private var showOptionsMenu: Bool = false
    @State private var selectedMedia: MediaItem? = nil
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    PlaylistHeaderCell(
                        height: 250,
                        title: media.trackName ?? "",
                        subtitle: media.artistName ?? "",
                        imageName: media.artworkUrl100?.absoluteString ?? ""
                    )
                    .readingFrame { frame in
                        showHeader = frame.maxY < 150
                    }
                    
                    PlaylistDescriptionCell(
                        media: media,
                        descriptionText: media.shortDescription ?? "",
                        userName: user.firstName,
                        subheadline: media.collectionName ?? "",
                        onAddToPlaylistPressed: nil,
                        onDownloadPressed: nil,
                        onSharePressed: nil,
                        onEllipsisPressed: nil,
                        onShufflePressed: nil,
                        onPlayPressed: nil
                    )
                    .padding(.horizontal, 16)
                    
                    ForEach(medias) { media in
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
                        .padding(.leading, 16)
                        .environment(\.modelContext, modelContext)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
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
            
            header
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            if playerManager.hasBeenPlayed {
                Color.clear.frame(height: 85) // `MusicPlayerView` 的高度
            }
        }
    }
    
    private func getData() async {
        do {
            medias = try await DatabaseHelper().getDefaultMusic()
        } catch {
            
        }
    }
    
    private func goToPlaylistView(media: MediaItem) {
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(media: media, user: user)
        }
    }
    
    private var header: some View {
        ZStack {
            Text(media.trackName ?? "")
                .font(.headline)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color.spotifyBlack)
                .offset(y: showHeader ? 0 : -40)
                .opacity(showHeader ? 1 : 0)
            
            Image(systemName: "chevron.left")
                .font(.title3)
                .padding(10)
                .background(showHeader ? Color.black.opacity(0.001) : Color.spotifyGray.opacity(0.7))
                .clipShape(Circle())
                .onTapGesture {
                    router.dismissScreen()
                }
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.spotifyWhite)
        .animation(.smooth(duration: 0.2), value: showHeader)
    }
}

#Preview {
    RouterView { _ in
        SpotifyPlaylistView()
    }
}
