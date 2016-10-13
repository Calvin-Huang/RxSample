//
//  RepoCell.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

import RxSwift

class RepoCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var browseButton: UIButton!
    
    var url: URL?
    
    var model: Repo! {
        didSet {
            titleLabel.text = model.title
            descriptionLabel.text = model.description
            url = URL(string: model.url)
        }
    }
    
    var viewController: UIViewController?
    
    func browseButtonClicked(_: AnyObject) {
        guard let url = url else { return }
        
        let webViewController = WebViewViewController()
        
        webViewController.loadViewIfNeeded()
        webViewController.webView.loadRequest(URLRequest(url: url))
        viewController?.present(webViewController, animated: true, completion: nil)
    }
}
