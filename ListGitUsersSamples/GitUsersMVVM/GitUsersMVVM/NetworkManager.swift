//
//  NetworkManager.swift
//  GitUsersMVVM
//
//  Created by Sandeep Khade on 24/10/23.
//

import Foundation


enum GHError: Error {
    
    case invalidURL
    case invalidResponse
    case invalidData
}

class NetworkManager {
    
    @Published private(set) var isRefreshing = false

    func getUser(url:String) async throws -> GitHubUser {
                
        isRefreshing = true
        defer { isRefreshing = false }
        guard let url = URL(string: url) else {
            throw GHError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getGitFollowers() async throws -> [GitFollowers] {
        
        let url = "https://api.github.com/users/sallen0400/followers?page=1&per_page=100"
        isRefreshing = true
        defer { isRefreshing = false }
        guard let url = URL(string: url) else {
            throw GHError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([GitFollowers].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}
