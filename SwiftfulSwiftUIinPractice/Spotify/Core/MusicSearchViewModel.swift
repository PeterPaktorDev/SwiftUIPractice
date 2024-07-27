//
//  MusicSearchViewModel.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/27.
//

import Foundation
import SwiftUI
import SwiftData
import Combine


class MusicSearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedMedia: MediaItem? = nil
    @Published var showOptionsMenu: Bool = false
    
    private let databaseHelper = DatabaseHelper()
    
    func performSearch() async {
        guard !searchTerm.isEmpty else {
            await MainActor.run {
                mediaItems = []
            }
            return
        }
        
        do {
            let items = try await databaseHelper.getMusic(term: searchTerm, limit: 50)
            await MainActor.run {
                mediaItems = items
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            await MainActor.run {
                mediaItems = []
            }
        }
    }
    
    func selectMedia(_ media: MediaItem) {
        selectedMedia = media.deepCopy()
        showOptionsMenu = true
    }
    
    func dismissOptionsMenu() {
        showOptionsMenu = false
    }
}
