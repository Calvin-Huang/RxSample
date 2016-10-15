//
//  SearchBar.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    var isFirstResponder: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self.base) { (searchBar, shouldBecomeResponder) in
            if shouldBecomeResponder {
                searchBar.becomeFirstResponder()
            } else {
                searchBar.resignFirstResponder()
            }
        }.asObserver()
    }
}
