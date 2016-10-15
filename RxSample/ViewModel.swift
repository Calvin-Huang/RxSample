//
//  ViewModel.swift
//  RxSample
//
//  Created by Calvin on 10/15/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper

class ViewModel {
    let disposeBag = DisposeBag()
    
    let browseURL: Variable<URL?> = Variable(nil)
    let repos: Variable<[Repo]> = Variable([])
    var query: Driver<String> = Driver.just("") {
        didSet {
            query
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
                .drive(repos)
                .addDisposableTo(disposeBag)
        }
    }
}
