//
//  AirbnbWebViewController.swift
//  Homely
//
//  Created by Madushani Lekam Wasam Liyanage on 1/11/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit
import WebKit

class AirbnbWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var airbnbURL = ""
    var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        
        setupWebView()
        
        let myURL = URL(string: airbnbURL)
        let myRequest = URLRequest(url: myURL!)
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
}
