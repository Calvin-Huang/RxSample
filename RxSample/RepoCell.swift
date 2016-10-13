//
//  RepoCell.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var browseButton: UIButton!
    
    var url: URL?
    
    override func awakeFromNib() {
        browseButton.addTarget(self, action: #selector(browseButtonClicked(_:)), for: .touchUpInside)
    }
    
    weak var viewController: UIViewController?
    
    func browseButtonClicked(_: AnyObject) {
        guard let url = url else { return }
        
        let webViewController = WebViewViewController()
        
        webViewController.loadViewIfNeeded()
        webViewController.webView.loadRequest(URLRequest(url: url))
        viewController?.present(webViewController, animated: true, completion: nil)
    }
}
