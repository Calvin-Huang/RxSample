//
//  RepoModel.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Foundation

struct Repo {
    let title: String
    let description: String
    let url: String
    
    init(title: String, description: String, url: String) {
        self.title = title
        self.description = description
        self.url = url
    }
}
