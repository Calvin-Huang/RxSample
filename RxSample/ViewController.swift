//
//  ViewController.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Moya
import ObjectMapper

class ViewController: UIViewController {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()

    var navigationBarTitle: String? {
        set {
            navigationBar.topItem?.title = newValue
        }
        
        get {
            return navigationBar.topItem?.title
        }
    }
    
    let browseURL: Variable<URL?> = Variable(nil)
    var repos: Driver<[Repo]> = Driver.just([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureTableView()
        
        browseURL
            .asObservable()
            .subscribe(onNext: { [weak self] (url: URL?) in
                let webViewController = WebViewViewController()
                
                webViewController.url = url
                self?.present(webViewController, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Methods
    private func configureTableView() {
        tableView.rowHeight = 74
        
        repos
            .drive(tableView.rx.items(cellIdentifier: "\(RepoCell.self)", cellType: RepoCell.self)) { [weak self] (_, model, cell) in
                cell.browseURL = self?.browseURL
                cell.model = model
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .modelSelected(Repo.self)
            .asDriver()
            .drive(onNext: { [weak self] repo in
                self?.navigationBarTitle = repo.title
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset
            .asDriver()
            .map { _ in false }
            .drive(searchBar.rx.isFirstResponder)
            .addDisposableTo(disposeBag)
    }
    
    private func configureSearchBar() {
        repos = searchBar.rx.text
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .flatMapLatest { query -> Driver<[Repo]> in
                if query.isEmpty {
                    return Driver.just([])
                } else {
                    return GitHubProvider.request(.searchRepo(query))
                        .map { response -> [Repo] in
                            guard
                                let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any],
                                let items = json?["items"] as? [[String: Any]],
                                let repos = Mapper<Repo>().mapArray(JSONArray: items)
                            else {
                                return []
                            }
                            
                            return repos
                        }
                        .asDriver(onErrorJustReturn: [])
                }
            }
    }
    
}
