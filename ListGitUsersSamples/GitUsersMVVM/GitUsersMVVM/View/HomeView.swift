//
//  HomeView.swift
//  GitUsersMVVM
//
//  Created by Sandeep Khade on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    @State private var followers: [GitFollowers] = []
    @State private var networkManager : NetworkManager = NetworkManager()
    @State private var searchTerm = ""
    
    var filterFollowers : [GitFollowers] {
        guard !searchTerm.isEmpty else { return followers }
        return followers.filter { $0.login.localizedStandardContains(searchTerm)
        }
    }
    var body: some View {
        NavigationStack {
            if networkManager.isRefreshing {
                ProgressView()
            } else {
                List(filterFollowers, id: \.id) { follower in
                    
                    NavigationLink {
                        UserView(urlString: follower.url)
                    } label: {
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 44,height: 44)
                            Text(follower.login)
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                    }
                }
                .navigationTitle("Followers")
                .task { followers = try! await networkManager.getGitFollowers()}
                .searchable(text: $searchTerm, prompt: "Serch followers")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
