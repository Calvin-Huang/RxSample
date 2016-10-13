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
        browseButton.addTarget(self, action: #selector(browseButton(_:)), for: .touchDragInside)
    }
    
    weak var viewController: UIViewController?
    
    func browseButton(_: AnyObject) {
        let webViewController = WebViewViewController()
        
        
        viewController?.present(webViewController, animated: true, completion: nil)
    }
}
