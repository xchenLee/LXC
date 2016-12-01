//
//  WebExplorer.swift
//  LXC
//
//  Created by renren on 16/3/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import WebKit

let  kSampleUrl = "http://www.appcoda.com"//"http://www.baidu.com"//

/**
    not load local File
    http://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8

    http://www.appcoda.com/webkit-framework-tutorial/
*/

class WebExplorer: UIViewController, WKNavigationDelegate, WKUIDelegate {
    

    var webView = WKWebView()
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        webView.frame = CGRect(x: 0, y: 0, width: width, height: height - 66)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        view.insertSubview(webView, belowSubview: progressView)
        
        let url = URL(string: kSampleUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        self.webView.allowsBackForwardNavigationGestures = true
        

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
        if (keyPath == "title") {
            title = webView.title
        }
    }

    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == WKNavigationType.linkActivated && !(navigationAction.request as NSURLRequest).url!.host!.lowercased().hasPrefix("www.appcoda.com")) {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }

}



















