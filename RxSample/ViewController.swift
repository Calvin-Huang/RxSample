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

    let viewModel = ViewModel()
    
    var navigationBarTitle: String? {
        set {
            navigationBar.topItem?.title = newValue
        }
        
        get {
            return navigationBar.topItem?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.searchDone = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationBarTitle = viewModel.repos[indexPath.row].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RepoCell.self)", for: indexPath) as! RepoCell
        let repo = viewModel.repos[indexPath.row]
        
        cell.viewController = self
        cell.titleLabel.text = repo.title
        cell.descriptionLabel.text = repo.description
        cell.url = URL(string: repo.url)
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}
