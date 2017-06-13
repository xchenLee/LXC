//
//  TumblrPostsByTag.swift
//  LXC
//
//  Created by renren on 16/8/9.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import SwiftyJSON
import TMTumblrSDK

let kTumblrPostsTagCell = "postTagCell"
let kTumblrPostsTagKey = "tagName"

class TumblrPostsByTag: TumblrPostsList {
    
    var tagName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDataHandler()
        self.tableView.mj_header.beginRefreshing()
        self.addObserver(self, forKeyPath: kTumblrPostsTagKey, options: .new, context: nil)
    }
    
    
    // MARK: - Custom Method
    func addDataHandler() {
        
        self.tableView.addPullDownRefresh {
            [weak self] in
            self?.tmpIDString = ""
            self?.requestTaggedPosts(0)
        }
        
        self.tableView.addPullUp2LoadMore {
            [weak self] in
            guard let firstlayout = self?.layouts.first, let firstPost = firstlayout.post else {
                self?.tableView.endLoadingMore()
                return
            }
            let timestamp = firstPost.timestamp
            self?.requestTaggedPosts(timestamp)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == kTumblrPostsTagKey {
            let newTagValue = change![NSKeyValueChangeKey.newKey] as! String
            self.title = newTagValue
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    /**
     刷新方法，当在tag页面点击的时候，在本页面刷新数据
     
     - parameter cell: cell
     - parameter tag:  name of tag
     */
    override func didClickTag(_ cell: TumblrNormalCell, tag: String) {
        self.setValue(tag, forKeyPath: kTumblrPostsTagKey)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: kTumblrPostsTagKey)
    }

}


extension TumblrPostsByTag {
    
    func requestTaggedPosts(_ before: Int) {
        
        var parameters = ["feature_type" : "everything"]
        if before > 0 {
            parameters["before"] = String(before)
        }
        
        TMAPIClient.sharedInstance().tagged(self.tagName, parameters:parameters) { [weak self] (result, error) in
            
            if error != nil {
                return
            }
            /**
             "tags" : [
             "新垣結衣",
             "aragaki  yui"
             ]
             */
            //TODO  Google 
            //Success
            
            let resultJSON = JSON(result!)
            var taggedPosts: [TumblrPost] = []
            if resultJSON.type == .array {
                for postObj in resultJSON.arrayValue {
                    let tumblrPost = TumblrPost()
                    tumblrPost.sjMap(postObj)
                    taggedPosts.append(tumblrPost)
                }
            }
            
            DispatchQueue.global().async {
                if taggedPosts.count == 0 {
                    self?.tableView.endRefreshing()
                    return
                }
                
                var tmpLayouts: [TumblrNormalLayout] = []
                var i = 0
                for tumblrPost in taggedPosts {
                    let id = tumblrPost.postId
                    if self != nil && !self!.tmpIDString.contains("\(id),") {
                        let layout = TumblrNormalLayout()
                        layout.fitPostData(tumblrPost)
                        tmpLayouts.append(layout)
                        self?.tmpIDString += "\(id),"
                    }
                    i += 1
                    print("layouts in \(i)")
                }
                
                DispatchQueue.main.async(execute: {
                    if before > 0 {
                        self?.layouts.append(contentsOf: tmpLayouts)
                        self?.tableView.endLoadingMore()
                        self?.tableView.reloadData()
                    } else {
                        self?.layouts = tmpLayouts
                        self?.tableView.endRefreshing()
                        self?.tableView.reloadData()
                    }
                    
                })
            }
        }
        
    }
}

