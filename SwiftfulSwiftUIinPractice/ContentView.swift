//
//  ContentView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting
import SwiftData

struct ContentView: View {
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.spotifyBlack)
        UITabBar.appearance().barTintColor = UIColor(Color.spotifyBlack)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.spotifyBlack.ignoresSafeArea()
                
                TabView {
                    RouterView { _ in
                        SpotifyHomeView()
                            .environment(\.modelContext, modelContainer.mainContext)
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                    RouterView { _ in
                        MusicSearchView()
                            .environment(\.modelContext, modelContainer.mainContext)
                    }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                    RouterView { _ in
                        FavoritesView()
                            .environment(\.modelContext, modelContainer.mainContext)
                    }
                    .tabItem {
                        Label("Library", systemImage: "rectangle.stack")
                    }
                }
                .tint(Color.white)
                
                VStack {
                    Spacer()
                    MusicPlayerView()
                        .padding(.horizontal, 8)
                        .background(Color.black.opacity(0.8))
                        .frame(width: geometry.size.width)
                        .offset(y: -geometry.safeAreaInsets.bottom - 65)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var modelContainer: ModelContainer {
        do {
            let schema = Schema([
                FavoriteMedia.self,
                MediaItem.self
            ])
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}

#Preview {
    RouterView { _ in
        ContentView()
    }
}
