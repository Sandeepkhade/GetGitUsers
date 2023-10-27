//
//  GithubUser.swift
//  GitUsersMVVM
//
//  Created by Sandeep Khade on 24/10/23.
//

import Foundation

struct GitHubUser: Codable {
    
    let login: String
    let avatarUrl: String
    let bio: String?
}
