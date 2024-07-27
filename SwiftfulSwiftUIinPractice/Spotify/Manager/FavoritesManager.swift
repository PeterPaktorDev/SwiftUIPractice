//
//  FavoritesManager.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/20.
//

import Foundation
import SwiftData
import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published private(set) var favoritesCache = Set<Int>()
    private var isCacheLoaded = false
    
    private init() {}
    
    private func loadCacheIfNeeded(context: ModelContext) {
        guard !isCacheLoaded else { return }
        let fetchDescriptor = FetchDescriptor<FavoriteMedia>()
        do {
            let favorites = try context.fetch(fetchDescriptor)
            favoritesCache = Set(favorites.compactMap { $0.media.id })
            isCacheLoaded = true
        } catch {
            print("Failed to load favorites cache: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(_ media: MediaItem, context: ModelContext) -> Bool {
        loadCacheIfNeeded(context: context)
        return favoritesCache.contains(media.id ?? -1)
    }
    
    func addToFavorites(_ media: MediaItem, context: ModelContext) {
        loadCacheIfNeeded(context: context)
        let favorite = FavoriteMedia(date: Date(), media: media)
        context.insert(favorite)
        favoritesCache.insert(media.id ?? -1)
        saveContext(context)
        objectWillChange.send() // Trigger update
    }
    
    func removeFromFavorites(_ media: MediaItem, context: ModelContext) {
        loadCacheIfNeeded(context: context)
        let fetchDescriptor = FetchDescriptor<FavoriteMedia>(predicate: #Predicate { $0.media.id == media.id })
        do {
            let favorites = try context.fetch(fetchDescriptor)
            for favorite in favorites {
                context.delete(favorite)
            }
            favoritesCache.remove(media.id ?? -1)
            saveContext(context)
            objectWillChange.send() // Trigger update
        } catch {
            print("Remove favorites error: \(error.localizedDescription)")
        }
    }
    
    func getAllFavorites(context: ModelContext) -> [FavoriteMedia] {
        loadCacheIfNeeded(context: context)
        let fetchDescriptor = FetchDescriptor<FavoriteMedia>(sortBy: [SortDescriptor(\.date, order: .forward)])
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch all favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    private func saveContext(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Save context error: \(error.localizedDescription)")
        }
    }
}
