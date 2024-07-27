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
    @StateObject private var viewModel = MusicSearchViewModel()
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            VStack {
                if viewModel.mediaItems.isEmpty {
                    Text("No songs found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.mediaItems, id: \.id) { media in
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
                                        viewModel.selectMedia(media)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            
            if let media = viewModel.selectedMedia, viewModel.showOptionsMenu {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        viewModel.dismissOptionsMenu()
                    }
                
                OptionsMenuView(
                    media: media,
                    onAddToLikedSongs: {
                        if media.isFavorite(context: modelContext) {
                            FavoritesManager.shared.removeFromFavorites(media, context: modelContext)
                        } else {
                            FavoritesManager.shared.addToFavorites(media, context: modelContext)
                        }
                        viewModel.dismissOptionsMenu()
                    },
                    onAddToPlaylist: {
                        // Add to playlist action
                        viewModel.dismissOptionsMenu()
                    },
                    onHideSong: {
                        // Hide song action
                        viewModel.dismissOptionsMenu()
                    },
                    onAddToQueue: {
                        // Add to queue action
                        viewModel.dismissOptionsMenu()
                    },
                    onShare: {
                        // Share action
                        viewModel.dismissOptionsMenu()
                    },
                    onStartJam: {
                        // Start a jam action
                        viewModel.dismissOptionsMenu()
                    },
                    onGoToRadio: {
                        // Go to radio action
                        viewModel.dismissOptionsMenu()
                    },
                    onDismiss: {
                        viewModel.dismissOptionsMenu()
                    }
                )
                .environment(\.modelContext, modelContext)
                .frame(maxWidth: .infinity)
                .padding()
                .cornerRadius(10)
            }
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Search for music")
        .onChange(of: viewModel.searchTerm) {
            Task {
                await viewModel.performSearch()
            }
        }
        .onChange(of: viewModel.showOptionsMenu) {
            if viewModel.showOptionsMenu {
                hideKeyboard()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MusicSearchView()
}
