//
//  MediaItem.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/10.
//

import Foundation
import SwiftData

struct ItunesResponse: Codable {
    let resultCount: Int
    let results: [MediaItem]
}

@Model
class MediaItem: Identifiable, Codable {
    @Attribute(.unique) var id: Int?
    var kind: String?
    var collectionId: Int?
    var trackId: Int?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var collectionCensoredName: String?
    var trackCensoredName: String?
    var collectionArtistId: Int?
    var collectionArtistViewUrl: URL?
    var collectionViewUrl: URL?
    var trackViewUrl: URL?
    var previewUrl: URL?
    var artworkUrl30: URL?
    var artworkUrl60: URL?
    var artworkUrl100: URL?
    var collectionPrice: Double?
    var trackPrice: Double?
    var trackRentalPrice: Double?
    var collectionHdPrice: Double?
    var trackHdPrice: Double?
    var trackHdRentalPrice: Double?
    var trackNumber: Int?
    var country: String?
    var shortDescription: String?
    var longDescription: String?
    
    init(id: Int? = nil, kind: String? = nil, collectionId: Int? = nil, trackId: Int? = nil, artistName: String? = nil, collectionName: String? = nil, trackName: String? = nil, collectionCensoredName: String? = nil, trackCensoredName: String? = nil, collectionArtistId: Int? = nil, collectionArtistViewUrl: URL? = nil, collectionViewUrl: URL? = nil, trackViewUrl: URL? = nil, previewUrl: URL? = nil, artworkUrl30: URL? = nil, artworkUrl60: URL? = nil, artworkUrl100: URL? = nil, collectionPrice: Double? = nil, trackPrice: Double? = nil, trackRentalPrice: Double? = nil, collectionHdPrice: Double? = nil, trackHdPrice: Double? = nil, trackHdRentalPrice: Double? = nil, trackNumber: Int? = nil, country: String? = nil, shortDescription: String? = nil, longDescription: String? = nil) {
        self.id = id
        self.kind = kind
        self.collectionId = collectionId
        self.trackId = trackId
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackName = trackName
        self.collectionCensoredName = collectionCensoredName
        self.trackCensoredName = trackCensoredName
        self.collectionArtistId = collectionArtistId
        self.collectionArtistViewUrl = collectionArtistViewUrl
        self.collectionViewUrl = collectionViewUrl
        self.trackViewUrl = trackViewUrl
        self.previewUrl = previewUrl
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.trackRentalPrice = trackRentalPrice
        self.collectionHdPrice = collectionHdPrice
        self.trackHdPrice = trackHdPrice
        self.trackHdRentalPrice = trackHdRentalPrice
        self.trackNumber = trackNumber
        self.country = country
        self.shortDescription = shortDescription
        self.longDescription = longDescription
    }
    
    // Codable 协议的编码和解码
    enum CodingKeys: String, CodingKey {
        case id = "trackId" // 如果 id 是 trackId
        case kind
        case collectionId
        case artistName
        case collectionName
        case trackName
        case collectionCensoredName
        case trackCensoredName
        case collectionArtistId
        case collectionArtistViewUrl
        case collectionViewUrl
        case trackViewUrl
        case previewUrl
        case artworkUrl30
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case trackPrice
        case trackRentalPrice
        case collectionHdPrice
        case trackHdPrice
        case trackHdRentalPrice
        case trackNumber
        case country
        case shortDescription
        case longDescription
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
        self.collectionId = try container.decodeIfPresent(Int.self, forKey: .collectionId)
        self.trackId = try container.decodeIfPresent(Int.self, forKey: .id)
        self.artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
        self.collectionCensoredName = try container.decodeIfPresent(String.self, forKey: .collectionCensoredName)
        self.trackCensoredName = try container.decodeIfPresent(String.self, forKey: .trackCensoredName)
        self.collectionArtistId = try container.decodeIfPresent(Int.self, forKey: .collectionArtistId)
        self.collectionArtistViewUrl = try container.decodeIfPresent(URL.self, forKey: .collectionArtistViewUrl)
        self.collectionViewUrl = try container.decodeIfPresent(URL.self, forKey: .collectionViewUrl)
        self.trackViewUrl = try container.decodeIfPresent(URL.self, forKey: .trackViewUrl)
        self.previewUrl = try container.decodeIfPresent(URL.self, forKey: .previewUrl)
        self.artworkUrl30 = try container.decodeIfPresent(URL.self, forKey: .artworkUrl30)
        self.artworkUrl60 = try container.decodeIfPresent(URL.self, forKey: .artworkUrl60)
        self.artworkUrl100 = try container.decodeIfPresent(URL.self, forKey: .artworkUrl100)
        self.collectionPrice = try container.decodeIfPresent(Double.self, forKey: .collectionPrice)
        self.trackPrice = try container.decodeIfPresent(Double.self, forKey: .trackPrice)
        self.trackRentalPrice = try container.decodeIfPresent(Double.self, forKey: .trackRentalPrice)
        self.collectionHdPrice = try container.decodeIfPresent(Double.self, forKey: .collectionHdPrice)
        self.trackHdPrice = try container.decodeIfPresent(Double.self, forKey: .trackHdPrice)
        self.trackHdRentalPrice = try container.decodeIfPresent(Double.self, forKey: .trackHdRentalPrice)
        self.trackNumber = try container.decodeIfPresent(Int.self, forKey: .trackNumber)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
        self.longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(kind, forKey: .kind)
        try container.encodeIfPresent(collectionId, forKey: .collectionId)
        try container.encodeIfPresent(trackId, forKey: .id)
        try container.encodeIfPresent(artistName, forKey: .artistName)
        try container.encodeIfPresent(collectionName, forKey: .collectionName)
        try container.encodeIfPresent(trackName, forKey: .trackName)
        try container.encodeIfPresent(collectionCensoredName, forKey: .collectionCensoredName)
        try container.encodeIfPresent(trackCensoredName, forKey: .trackCensoredName)
        try container.encodeIfPresent(collectionArtistId, forKey: .collectionArtistId)
        try container.encodeIfPresent(collectionArtistViewUrl, forKey: .collectionArtistViewUrl)
        try container.encodeIfPresent(collectionViewUrl, forKey: .collectionViewUrl)
        try container.encodeIfPresent(trackViewUrl, forKey: .trackViewUrl)
        try container.encodeIfPresent(previewUrl, forKey: .previewUrl)
        try container.encodeIfPresent(artworkUrl30, forKey: .artworkUrl30)
        try container.encodeIfPresent(artworkUrl60, forKey: .artworkUrl60)
        try container.encodeIfPresent(artworkUrl100, forKey: .artworkUrl100)
        try container.encodeIfPresent(collectionPrice, forKey: .collectionPrice)
        try container.encodeIfPresent(trackPrice, forKey: .trackPrice)
        try container.encodeIfPresent(trackRentalPrice, forKey: .trackRentalPrice)
        try container.encodeIfPresent(collectionHdPrice, forKey: .collectionHdPrice)
        try container.encodeIfPresent(trackHdPrice, forKey: .trackHdPrice)
        try container.encodeIfPresent(trackHdRentalPrice, forKey: .trackHdRentalPrice)
        try container.encodeIfPresent(trackNumber, forKey: .trackNumber)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(shortDescription, forKey: .shortDescription)
        try container.encodeIfPresent(longDescription, forKey: .longDescription)
    }
    
    static var mock: MediaItem {
        return MediaItem(kind: "Kind", collectionId: 1, trackId: 2, artistName: "artistName", collectionName: "collectionName", trackName: "trackName", collectionCensoredName: "collectionCensoredName", trackCensoredName: "trackCensoredName", collectionArtistId: 3, collectionArtistViewUrl: URL(string: "https://example.com"), collectionViewUrl: URL(string: "https://example.com"), trackViewUrl: URL(string: "https://example.com"), previewUrl: URL(string: "https://example.com"), artworkUrl30: URL(string: "https://example.com"), artworkUrl60: URL(string: "https://example.com"), artworkUrl100: URL(string: "https://example.com"), collectionPrice: 0, trackPrice: 0, trackRentalPrice: 0, collectionHdPrice: 0, trackHdPrice: 0, trackHdRentalPrice: 0, trackNumber: 4, country: "country", shortDescription: "shortDescription", longDescription: "longDescription")
    }
}

extension MediaItem {
    func isFavorite(context: ModelContext) -> Bool {
        return FavoritesManager.shared.isFavorite(self, context: context)
    }
}

extension MediaItem {
    func deepCopy() -> MediaItem {
        return MediaItem(
            id: self.id,
            kind: self.kind,
            collectionId: self.collectionId,
            trackId: self.trackId,
            artistName: self.artistName,
            collectionName: self.collectionName,
            trackName: self.trackName,
            collectionCensoredName: self.collectionCensoredName,
            trackCensoredName: self.trackCensoredName,
            collectionArtistId: self.collectionArtistId,
            collectionArtistViewUrl: self.collectionArtistViewUrl,
            collectionViewUrl: self.collectionViewUrl,
            trackViewUrl: self.trackViewUrl,
            previewUrl: self.previewUrl,
            artworkUrl30: self.artworkUrl30,
            artworkUrl60: self.artworkUrl60,
            artworkUrl100: self.artworkUrl100,
            collectionPrice: self.collectionPrice,
            trackPrice: self.trackPrice,
            trackRentalPrice: self.trackRentalPrice,
            collectionHdPrice: self.collectionHdPrice,
            trackHdPrice: self.trackHdPrice,
            trackHdRentalPrice: self.trackHdRentalPrice,
            trackNumber: self.trackNumber,
            country: self.country,
            shortDescription: self.shortDescription,
            longDescription: self.longDescription
        )
    }
}
