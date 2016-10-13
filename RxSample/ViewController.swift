//
//  ViewController.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var navigationBarTitle: String? {
        set {
            navigationBar.topItem?.title = newValue
        }
        
        get {
            return navigationBar.topItem?.title
        }
    }
    
    var repos: [Repo] = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationBarTitle = repos[indexPath.row].title
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)", for: indexPath) as! RepoCell
        let repo = repos[indexPath.row]
        
        cell.titleLabel.text = repo.title
        cell.descriptionLabel.text = repo.description
        cell.url = URL(string: repo.url)
        
        return cell
    }
}
