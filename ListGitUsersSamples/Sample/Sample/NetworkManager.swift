//
//  NetworkManager.swift
//  Sample
//
//  Created by Sandeep Khade on 27/10/23.
//

import Foundation

class NetworkManager{
    
    let url = URL(string: "https://api.github.com/users/Sandeepkhade/following?")
    func fetchFollowerData(completion: @escaping ([Follower]) -> ()) {
        URLSession.shared.request(url: url, expecting: [Follower].self
        ) { result in
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    completion(followers)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchUserData(url: String, completion: @escaping(UserDetails) -> ()) {
        let urlIn = URL(string: url)
        URLSession.shared.request(url: urlIn, expecting: UserDetails.self
        ) { result in
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    completion(followers)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension URLSession {
    
    enum CustomError: Error {
        case invalidURL
        case invalidData
    }
    func request <T: Codable>(url: URL?,expecting: T.Type,completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        let task = self.dataTask(with: url) { data, _, error in
            guard let data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct Follower : Codable {
    let id: Int
    let login: String
    let avatar_url: String
    let url: String
}

struct UserDetails : Codable {
    let login : String
    let avatar_url: String
    let bio : String?
}

//    func fetchData(completed: @escaping ([Follower]) -> ()) {
//
//        var followers = [Follower]()
//        let url = URL(string: "https://api.github.com/users/sallen0400/followers?page=1&per_page=1000")
//
//        URLSession.shared.dataTask(with: url!) { data, response, err in
//            if err == nil {
//                do {
//                    followers = try JSONDecoder().decode([Follower].self, from: data!)
//                    DispatchQueue.main.async {
//                        completed(followers)
//                    }
//                }
//                catch {
//                    print("error fetching data from api")
//                }
//            }
//        }.resume()
//    }
