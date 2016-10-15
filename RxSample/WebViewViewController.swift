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

import WebKit

class WebViewViewController: UIViewController {
    @IBOutlet var undoButton: UIBarButtonItem!
    @IBOutlet var redoButton: UIBarButtonItem!
    @IBOutlet var dismissButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 64),
                size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 64)
            )
        )
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(webView)
        
        webView.rx.canGoBack
            .shareReplay(1)
            .asDriver(onErrorJustReturn: false)
            .drive(self.undoButton.rx.enabled)
            .addDisposableTo(self.disposeBag)
        
        webView.rx.canGoForward
            .shareReplay(1)
            .asDriver(onErrorJustReturn: false)
            .drive(self.redoButton.rx.enabled)
            .addDisposableTo(self.disposeBag)
        
        self.undoButton.rx.tap
            .subscribe { _ in self.webView.goBack() }
            .addDisposableTo(self.disposeBag)
        
        self.redoButton.rx.tap
            .subscribe { _ in self.webView.goForward() }
            .addDisposableTo(self.disposeBag)
        
        self.dismissButton.rx.tap
            .subscribe { _ in self.dismiss(animated: true, completion: nil) }
            .addDisposableTo(self.disposeBag)
        
        return webView
    }()
    
    var url: URL? {
        didSet {
            guard let url = url else { return }
            
            webView.load(URLRequest(url: url))
        }
    }
}
