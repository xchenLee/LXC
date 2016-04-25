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
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        view.insertSubview(webView, belowSubview: progressView)
        
        let url = NSURL(string: kSampleUrl)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        self.webView.allowsBackForwardNavigationGestures = true
        

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
        if (keyPath == "title") {
            title = webView.title
        }
    }

    
    // MARK: - WKNavigationDelegate
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == WKNavigationType.LinkActivated && !navigationAction.request.URL!.host!.lowercaseString.hasPrefix("www.appcoda.com")) {
            UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }

}



















