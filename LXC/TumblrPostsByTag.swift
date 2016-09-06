//
//  TumblrPostsByTag.swift
//  LXC
//
//  Created by renren on 16/8/9.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import TMTumblrSDK

let kTumblrPostsTagCell = "postTagCell"


class TumblrPostsByTag: TumblrPostsList {
    
    var tagName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDataHandler()
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    // MARK: - Custom Method
    func addDataHandler() {
        
        self.tableView.addPullDownRefresh {
            self.tmpIDString = ""
            self.requestTaggedPosts(0)
        }
        
        self.tableView.addPullUp2LoadMore {
            guard let firstlayout = self.layouts.first, let firstPost = firstlayout.post else {
                self.tableView.endLoadingMore()
                return
            }
            let timestamp = firstPost.timestamp
            self.requestTaggedPosts(timestamp)
        }
    }
    
    /**
     重新方法，当在tag页面点击的时候，在本页面刷新数据
     
     - parameter cell: cell
     - parameter tag:  name of tag
     */
    override func didClickTag(cell: TumblrNormalCell, tag: String) {
        self.tagName = tag
        self.title = tag
        self.tableView.mj_header.beginRefreshing()
    }

}


extension TumblrPostsByTag {
    
    func requestTaggedPosts(before: Int) {
        
        var parameters = ["feature_type" : "everything"]
        if before > 0 {
            parameters["before"] = String(before)
        }
        
        TMAPIClient.sharedInstance().tagged(self.tagName, parameters:parameters) { (result, error) in
            
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
            //let resultJSON = JSON(result)
            let taggedPosts = Mapper<TumblrPost>().mapArray(result)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                guard let posts = taggedPosts else {
                    self.tableView.endRefreshing()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showTextHUD("no posts get")
                    })
                    return
                }
                
                var tmpLayouts: [TumblrNormalLayout] = []
                var i = 0
                for tumblrPost in posts {
                    let id = tumblrPost.postId
                    if !self.tmpIDString.containsString("\(id),") {
                        let layout = TumblrNormalLayout()
                        layout.fitPostData(tumblrPost)
                        tmpLayouts.append(layout)
                        self.tmpIDString += "\(id),"
                    }
                    i += 1
                    print("layouts in \(i)")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    if before > 0 {
                        self.layouts.appendContentsOf(tmpLayouts)
                        self.tableView.endLoadingMore()
                        self.tableView.reloadData()
                    } else {
                        self.layouts = tmpLayouts
                        self.tableView.endRefreshing()
                        self.tableView.reloadData()
                    }
                    
                })
            })
            
        }
        
        
    }
}









