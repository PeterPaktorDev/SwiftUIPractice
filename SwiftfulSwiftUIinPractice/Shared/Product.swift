//
//  Product.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import Foundation

struct CollectionRow: Identifiable {
    let id = UUID().uuidString
    let title: String
    let medias: [MediaItem]
}
