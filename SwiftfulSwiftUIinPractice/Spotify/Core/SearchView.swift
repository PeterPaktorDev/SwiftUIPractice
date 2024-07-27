//
//  SearchView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/22.
//

import Foundation
import SwiftUI
import SwiftData

struct MusicSearchView: View {
    @State private var searchTerm: String = ""
    @State private var mediaItems: [MediaItem] = []
    @State private var selectedMedia: MediaItem? = nil
    @State private var showOptionsMenu: Bool = false
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            VStack {
                if mediaItems.isEmpty {
                    Text("No songs found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(mediaItems, id: \.id) { media in
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
                }
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
                            FavoritesManager.shared.removeFromFavorites(media, context: modelContext)
                        } else {
                            FavoritesManager.shared.addToFavorites(media, context: modelContext)
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
        .searchable(text: $searchTerm, prompt: "Search for music")
        .onChange(of: searchTerm) {
            Task {
                await performSearch(term: searchTerm)
            }
        }
        .onChange(of: showOptionsMenu) {
            if showOptionsMenu {
                hideKeyboard()
            }
        }
    }
    
    private func performSearch(term: String) async {
        guard !term.isEmpty else {
            mediaItems = []
            return
        }
        
        do {
            let helper = DatabaseHelper()
            mediaItems = try await helper.getMusic(term: term, limit: 50)
        } catch {
            print("Error: \(error.localizedDescription)")
            mediaItems = []
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MusicSearchView()
}
