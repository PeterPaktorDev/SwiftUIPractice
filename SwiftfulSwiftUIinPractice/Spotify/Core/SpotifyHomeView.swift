import SwiftUI
import SwiftfulUI
import SwiftfulRouting
import SwiftData

struct SpotifyHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.router) var router
    
    @StateObject private var viewModel = SpotifyHomeViewModel()
    @ObservedObject var playerManager = MusicPlayerManager.shared
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders], content: {
                    Section {
                        VStack(spacing: 16) {
                            recentsSection
                                .padding(.horizontal, 16)

                            if let media = viewModel.newRelease {
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
            viewModel.setModelContext(modelContext)
            await viewModel.getData()
        }
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            if playerManager.hasBeenPlayed {
                Color.clear.frame(height: 85)
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            ZStack {
                if let currentUser = viewModel.currentUser {
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
                            isSelected: category == viewModel.selectedCategory
                        )
                        .onTapGesture {
                            viewModel.selectedCategory = category
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
        NonLazyVGrid(columns: 2, alignment: .center, spacing: 10, items: viewModel.medias) { media in
            if let media {
                SpotifyRecentsCell(
                    media: media
                )
                .asButton(.press) {
                    viewModel.goToPlaylistView(media: media, router: router)
                    MusicPlayerManager.shared.playTrack(media)
                }
            }
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
                viewModel.toggleFavorite(media: media)
            },
            onPlayPressed: {
                viewModel.goToPlaylistView(media: media, router: router)
                MusicPlayerManager.shared.playTrack(media)
            }
        )
    }
    
    private var listRows: some View {
        ForEach(viewModel.collectionRows) { row in
            VStack(spacing: 8) {
                Text(row.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.spotifyWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(row.medias) { media in
                            ImageTitleRowCell(
                                imageSize: 120,
                                imageName: media.artworkUrl100?.absoluteString ?? "",
                                title: media.trackName ?? ""
                            )
                            .asButton(.press) {
                                viewModel.goToPlaylistView(media: media, router: router)
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

//#Preview {
//    RouterView { _ in
//        SpotifyHomeView(modelContext: ModelContext(container: .mock))
//    }
//}
