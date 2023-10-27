//
//  ViewController.swift
//  Sample
//
//  Created by Sandeep Khade on 27/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var followers = [Follower]()
    let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.fetchFollowerData { followers in
            self.followers = followers
            self.tableView.reloadData()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "tableView")
        let follower = followers[indexPath.row]
        cell.textLabel?.text = follower.login.capitalizingFirstLetter()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.follower = followers[tableView.indexPathForSelectedRow!.row]
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.followers.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
