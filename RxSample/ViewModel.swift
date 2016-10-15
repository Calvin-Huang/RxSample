//
//  ViewModel.swift
//  RxSample
//
//  Created by Calvin on 10/15/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import ObjectMapper

class ViewModel {
    var repos: [Repo] = [Repo]()
    var query: String = "" {
        didSet {
            if query.isEmpty { return }
            
            GitHubProvider.request(.searchRepo(query)) { [weak self] (result) in
                
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
                    self?.searchDone?()
                case let .failure(error):
                    self?.searchError?(error)
                }
            }
        }
    }
    
    var searchDone: (() -> Void)?
    var searchError: ((Error) -> Void)?
}
