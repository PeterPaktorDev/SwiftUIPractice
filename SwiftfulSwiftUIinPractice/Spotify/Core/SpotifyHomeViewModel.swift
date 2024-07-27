//
//  SpotifyHomeViewModel.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/27.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting
import SwiftData

class SpotifyHomeViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var selectedCategory: Category? = nil
    @Published var collectionRows: [CollectionRow] = []
    @Published var medias: [MediaItem] = []
    @Published var newRelease: MediaItem? = nil
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func getData() async {
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
            
            collectionRows = mediaDictionary.map { (collectionName, medias) in
                CollectionRow(title: collectionName.capitalized, medias: medias)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func goToPlaylistView(media: MediaItem, router: AnyRouter) {
        guard let currentUser, let modelContext = modelContext else { return }
        
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(media: media, user: currentUser)
                .environment(\.modelContext, modelContext)
        }
    }
    
    func toggleFavorite(media: MediaItem) {
        guard let modelContext = modelContext else { return }
        if FavoritesManager.shared.isFavorite(media, context: modelContext) {
            FavoritesManager.shared.removeFromFavorites(media, context: modelContext)
        } else {
            FavoritesManager.shared.addToFavorites(media, context: modelContext)
        }
    }
}
