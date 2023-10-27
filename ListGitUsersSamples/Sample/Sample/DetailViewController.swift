//
//  DetailViewController.swift
//  Sample
//
//  Created by Sandeep Khade on 27/10/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userGitBioLbl: UILabel!
    
    let network = NetworkManager()
    var follower : Follower?
    var userDetail : UserDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.layer.cornerRadius = 40
        userImageView.backgroundColor = .white
        
        userNameLbl.text = self.follower?.login.capitalizingFirstLetter()
        network.fetchUserData(url: follower?.url ?? "") {
            userDetails in
            self.userDetail = userDetails
            self.userGitBioLbl.text = self.userDetail?.bio ?? "User has not added the Bio"
            
            self.userImageView.downloaded(from: self.follower?.avatar_url ?? "")
        }
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
