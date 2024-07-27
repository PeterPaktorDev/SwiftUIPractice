//
//  OptionsMenuView.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/20.
//

import SwiftUI
import SwiftData

struct OptionsMenuView: View {
    @Environment(\.modelContext) private var modelContext
    var media: MediaItem
    var onAddToLikedSongs: (() -> Void)?
    var onAddToPlaylist: (() -> Void)?
    var onHideSong: (() -> Void)?
    var onAddToQueue: (() -> Void)?
    var onShare: (() -> Void)?
    var onStartJam: (() -> Void)?
    var onGoToRadio: (() -> Void)?
    var onDismiss: (() -> Void)?

    @State private var isFavorite: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ImageLoaderView(urlString: media.artworkUrl100?.absoluteString ?? "")
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(media.trackName ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(media.artistName ?? "") • \(media.collectionName ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Divider()
            
            menuButton(
                title: isFavorite ? "Remove from Liked Songs" : "Add to Liked Songs",
                systemImage: "heart.fill",
                action: {
                    onAddToLikedSongs?()
                    isFavorite.toggle()
                },
                color: isFavorite ? .green : .white
            )
            menuButton(title: "Add to playlist", systemImage: "plus", action: onAddToPlaylist)
            menuButton(title: "Hide song", systemImage: "minus.circle", action: onHideSong)
            menuButton(title: "Add to queue", systemImage: "text.insert", action: onAddToQueue)
            menuButton(title: "Share", systemImage: "square.and.arrow.up", action: onShare)
            menuButton(title: "Start a Jam", systemImage: "person.3", action: onStartJam)
            menuButton(title: "Go to radio", systemImage: "dot.radiowaves.left.and.right", action: onGoToRadio)
            menuButton(title: "Cancel", systemImage: "xmark", action: onDismiss)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .foregroundColor(.white)
        .onAppear {
            isFavorite = FavoritesManager.shared.isFavorite(media, context: modelContext)
        }
    }
    
    private func menuButton(title: String, systemImage: String, action: (() -> Void)?, color: Color = .white) -> some View {
        Button(action: action ?? {}) {
            HStack {
                Label(title, systemImage: systemImage)
                    .foregroundColor(color)
                    .padding(.horizontal)
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 25)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
