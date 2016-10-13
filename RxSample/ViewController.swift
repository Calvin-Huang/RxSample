//
//  ViewController.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

// import Moya_ObjectMapper
import ObjectMapper

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
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)", for: indexPath) as! RepoCell
        let repo = repos[indexPath.row]
        
        cell.viewController = self
        cell.titleLabel.text = repo.title
        cell.descriptionLabel.text = repo.description
        cell.url = URL(string: repo.url)
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        GitHubProvider.request(.searchRepo(searchText)) { [weak self] (result) in
            
            var errorMessage = ""
            var success = true
            
            switch result {
            case let .success(response):
                if
                    let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any],
                    let items = json?["items"] as? [[String: Any]],
                    let repos = Mapper<Repo>().mapArray(JSONArray: items)
                {
                    
                    self?.repos = repos
                } else {
                    self?.repos = []
                }
                self?.tableView.reloadData()
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                
                errorMessage = error.description
                success = false
            }
            
            if !success {
                let alertController = UIAlertController(title: "Error!!", message: errorMessage, preferredStyle: .alert)
                alertController.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self?.dismiss(animated: true, completion: nil)
                    })
                )
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}
