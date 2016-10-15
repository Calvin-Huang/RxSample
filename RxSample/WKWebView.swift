//
//  WKWebView.swift
//  RxSample
//
//  Created by Calvin on 10/15/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import WebKit

import RxSwift

extension Reactive where Base: WKWebView {
    var canGoBack: Observable<Bool> {
        return self.observe(Bool.self, "canGoBack")
            .map { print("canGoBack: \($0)"); return $0 ?? false }
    }
    
    var canGoForward: Observable<Bool> {
        return self.observe(Bool.self, "canGoForward")
            .map { print("canGoForward: \($0)");return $0 ?? false }
    }
}
