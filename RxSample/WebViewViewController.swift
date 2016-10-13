//
//  WebViewViewController.swift
//  RxSample
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var undoButton: UIBarButtonItem!
    @IBOutlet var redoButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissButtonClicked(_: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func undoButtonClicked(_: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func redoButtonClicked(_: AnyObject) {
        webView.goForward()
    }

}

extension WebViewViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        undoButton.isEnabled = webView.canGoBack
        redoButton.isEnabled = webView.canGoForward
    }
}
