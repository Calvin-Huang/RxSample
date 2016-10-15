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
    var viewModel: ViewModel!
    
    var disposeBag: DisposeBag?
    
    var model: Repo! {
        didSet {
            let disposeBag = DisposeBag()
            
            titleLabel.text = model.title
            descriptionLabel.text = model.description
            url = URL(string: model.url)
            
            browseButton.rx.tap
                .map { [weak self] _ in self?.url }
                .bindTo(viewModel.browseURL)
                .addDisposableTo(disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        disposeBag = nil
    }
}
