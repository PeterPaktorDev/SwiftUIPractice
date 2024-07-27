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
    @Published var isSearching: Bool = false
    @Published var hasSearched: Bool = false
    
    private let databaseHelper = DatabaseHelper()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        $searchTerm
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] term in
                if term.isEmpty {
                    self?.clearSearch()
                } else {
                    self?.performSearch(term: term)
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(term: String) {
        isSearching = true
        hasSearched = true
        
        Task {
            do {
                let items = try await databaseHelper.getMusic(term: term, limit: 50)
                await MainActor.run {
                    mediaItems = items
                    isSearching = false
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                await MainActor.run {
                    mediaItems = []
                    isSearching = false
                }
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
    
    private func clearSearch() {
        mediaItems = []
        isSearching = false
        hasSearched = false
    }
}
