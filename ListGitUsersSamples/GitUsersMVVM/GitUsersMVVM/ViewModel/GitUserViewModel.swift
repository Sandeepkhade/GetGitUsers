//
//  GitUserViewModel.swift
//  GitUsersMVVM
//
//  Created by Sandeep Khade on 25/10/23.
//

import Foundation

final class GitUserViewModel: ObservableObject {
    
    @Published var followers: [GitFollowers] = []
    @Published var gitUsers: [GitHubUser] = []
    @Published private(set) var isRefreshing = false
    
    @MainActor
    func getUser(url:String) async throws -> GitHubUser {
        
        if let url = URL(string: url) {
            
            isRefreshing = true
            defer { isRefreshing = false }
            
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
        } else {
            throw GHError.invalidURL
        }
    }
    @MainActor
    func getGitFollowers() async throws {
        
        let url = "https://api.github.com/users/sallen0400/followers?page=1&per_page=100"
        if let url = URL(string: url) {
            
            isRefreshing = true
            defer { isRefreshing = false }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GHError.invalidResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.followers = try decoder.decode([GitFollowers].self, from: data)
            } catch {
                throw GHError.invalidData
            }
        } else {
            throw GHError.invalidURL
        }
    }
}
extension GitUserViewModel {
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Failed to decode response"
            case .custom(let error):
                return error.localizedDescription
            case .invalidStatusCode:
                return "Invalid Status code isn't within a valid range"
            }
        }
    }
}


