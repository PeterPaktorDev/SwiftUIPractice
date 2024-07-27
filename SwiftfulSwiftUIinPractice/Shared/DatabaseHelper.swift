//
//  DatabaseHelper.swift
//  SwiftfulSwiftUIinPractice
//
//  Created by Nick Sarno on 2/16/24.
//

import Foundation

struct DatabaseHelper {
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "https://dummyjson.com/users") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let users = try JSONDecoder().decode(UserArray.self, from: data)
        return users.users
    }
    
    func getDefaultMusic() async throws -> [MediaItem] {
        try await getMusic(term: "ONE OK ROCK", limit: 50)
    }
    
    func getMusic(term: String, limit: Int) async throws -> [MediaItem] {
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ItunesResponse.self, from: data)
        return response.results
    }
}
