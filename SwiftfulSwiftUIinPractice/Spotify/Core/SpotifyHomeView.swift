//
//  SpotifyHomeView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct SpotifyHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    @Environment(\.router) var router

    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var collectionRows: [CollectionRow] = []
    @State private var medias: [MediaItem] = []
    @State private var newRelease: MediaItem? = nil
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders], content: {
                    Section {
                        VStack(spacing: 16) {
                            recentsSection
                                .padding(.horizontal, 16)

                            if let media = newRelease {
                                newReleaseSection(media: media)
                                    .padding(.horizontal, 16)
                            }
                            
                            listRows
                        }
                    } header: {
                        header
                    }
                })
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .clipped()
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
        guard medias.isEmpty else { return }
        
        do {
            async let userFetch = DatabaseHelper().getUsers().first
            async let allMediaFetch = DatabaseHelper().getDefaultMusic()
            
            let (user, allMedias) = await (try userFetch, try allMediaFetch)
            
            currentUser = user
            newRelease = allMedias.randomElement()
            medias = Array(allMedias.prefix(8))
            
            var mediaDictionary: [String: [MediaItem]] = [:]
            
            for media in allMedias {
                if let artistName = media.artistName {
                    mediaDictionary[artistName, default: []].append(media)
                }
            }
            
            let rows: [CollectionRow] = mediaDictionary.map { (collectionName, medias) in
                CollectionRow(title: collectionName.capitalized, medias: medias)
            }
            
            collectionRows = rows
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            ZStack {
                if let currentUser {
                    ImageLoaderView(urlString: currentUser.image)
                        .background(.spotifyWhite)
                        .clipShape(Circle())
                        .onTapGesture {
                            router.dismissScreen()
                        }
                }
            }
            .frame(width: 35, height: 35)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(Category.allCases, id: \.self) { category in
                        SpotifyCategoryCell(
                            title: category.rawValue.capitalized,
                            isSelected: category == selectedCategory
                        )
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 24)
        .padding(.leading, 8)
        .frame(maxWidth: .infinity)
        .background(Color.spotifyBlack)
    }
    
    private var recentsSection: some View {
        NonLazyVGrid(columns: 2, alignment: .center, spacing: 10, items: medias) { media in
            if let media {
                SpotifyRecentsCell(
                    media: media
                )
                .asButton(.press) {
                    goToPlaylistView(media: media)
                    MusicPlayerManager.shared.playTrack(media)
                }
            }
        }
    }
    
    private func goToPlaylistView(media: MediaItem) {
        guard let currentUser else { return }
        
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(media: media, user: currentUser)
                .environment(\.modelContext, modelContext)
        }
    }
    
    private func newReleaseSection(media: MediaItem) -> some View {
        SpotifyNewReleaseCell(
            media: media,
            imageName: media.artworkUrl100?.absoluteString ?? "",
            headline: "New release from",
            subheadline: media.artistName,
            title: media.collectionName,
            subtitle: media.artistName,
            onAddToPlaylistPressed: {
                if FavoritesManager.shared.isFavorite(media, context: modelContext) {
                        FavoritesManager.shared.removeFromFavorites(media, context: modelContext)
                    } else {
                        FavoritesManager.shared.addToFavorites(media, context: modelContext)
                    }
            },
            onPlayPressed: {
                goToPlaylistView(media: media)
                MusicPlayerManager.shared.playTrack(media)
            }
        )
    }
    
    private var listRows: some View {
        ForEach(collectionRows) { row in
            VStack(spacing: 8) {
                Text(row.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.spotifyWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 16) { // 使用 LazyHStack
                        ForEach(row.medias) { media in
                            ImageTitleRowCell(
                                imageSize: 120,
                                imageName: media.artworkUrl100?.absoluteString ?? "",
                                title: media.trackName ?? ""
                            )
                            .asButton(.press) {
                                goToPlaylistView(media: media)
                                MusicPlayerManager.shared.playTrack(media)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    RouterView { _ in
        SpotifyHomeView()
    }
}
