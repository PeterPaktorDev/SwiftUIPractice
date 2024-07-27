//
//  LibraryManager.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Peter on 2024/7/19.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class FavoriteMedia: Identifiable {
    @Attribute(.unique) var id: Int
    var date: Date
    var media: MediaItem
    
    init(date: Date, media: MediaItem) {
        self.id = media.id ?? -1  // 您可以根据需要处理 nil 值
        self.date = date
        self.media = media
    }
}
