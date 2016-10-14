//
//  WebViewViewController.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class WebViewViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var undoButton: UIBarButtonItem!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var dismissButton: UIBarButtonItem!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.rx.observe(Bool.self, "canGoBack")
            .asDriver(onErrorJustReturn: false)
            .map { $0 ?? false }
            .drive(undoButton.rx.enabled)
            .addDisposableTo(disposeBag)
        
        webView.rx.observe(Bool.self, "canGoForward")
            .asDriver(onErrorJustReturn: false)
            .map { $0 ?? false }
            .drive(redoButton.rx.enabled)
            .addDisposableTo(disposeBag)
        
        undoButton.rx.tap
            .subscribe { _ in self.webView.goBack() }
            .addDisposableTo(disposeBag)
        
        redoButton.rx.tap
            .subscribe { _ in self.webView.goForward() }
            .addDisposableTo(disposeBag)
        
        dismissButton.rx.tap
            .subscribe { _ in self.dismiss(animated: true, completion: nil) }
            .addDisposableTo(disposeBag)
    }
    
}
