//
//  UserView.swift
//  GitUsersMVVM
//
//  Created by Sandeep Khade on 24/10/23.
//

import SwiftUI

struct UserView: View {
    
    @State private var user: GitHubUser?
    @State private var networkManager : NetworkManager = NetworkManager()
    var urlString : String
    
    var body: some View {
        VStack(spacing: 20) {
            
            if networkManager.isRefreshing {
                ProgressView()
            } else {
                
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                }
                .frame(width: 120,height: 120)
                
                Text(user?.login ?? "Login Placeholde")
                    .bold()
                    .font(.title3)
                
                Text(user?.bio ?? "User Bio not available")
                    .padding()
                
                Spacer()
            }
        }
        .padding()
        .task {
            do{
                user = try await networkManager.getUser(url: urlString)
                print("\(urlString)")
                
            } catch GHError.invalidURL {
                print("Invalid URL")
            } catch GHError.invalidResponse {
                print("Invalid Response")
            } catch GHError.invalidData {
                print("Invalid Data")
            } catch {
                print("unexpected error")
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(urlString: "")
    }
}
