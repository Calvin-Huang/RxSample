//
//  RepoModel.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import Foundation

import ObjectMapper

struct Repo: Mappable {
    var title: String!
    var description: String!
    var url: String!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["name"]
        description <- map["description"]
        url <- map["html_url"]
    }
}
