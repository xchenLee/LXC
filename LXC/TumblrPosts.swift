//
//  TumblrPosts.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK
import SwiftyJSON
import MediaPlayer
import AVKit


class TumblrPosts: TumblrPostsList, UINavigationControllerDelegate {
    
    //
    open var blogName: String = ""
    open var needAlphaBar: Bool = false
    
    fileprivate var writeCenter: CGPoint = CGPoint.zero
    
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDataHandler()
        self.tableView.separatorStyle = .none
        
        self.tableView.mj_header.beginRefreshing()
        self.navigationController?.delegate = self
        
        let fpsLabel = FPSLabel()
        fpsLabel.frame = CGRect(x: 10, y: self.view.height - 20, width: 65, height: 25)
        self.navigationController?.view.addSubview(fpsLabel)
        
        if self.needAlphaBar {
            self.navBarBackgroundAlpha = 0.0
        }
    }
    
    func addDataHandler() {
        
        self.tableView.addPullDownRefresh {
            self.postsCount = 0
            self.tmpIDString = ""
            self.requestDashboard(0)
        }
        
        self.tableView.addPullUp2LoadMore {
            guard let firstlayout = self.layouts.last, let _ = firstlayout.post else {
                self.tableView.endLoadingMore()
                return
            }
            self.requestDashboard(self.postsCount)
            
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }

}

// MARK: - extension for request datas
extension TumblrPosts {
    
    func requestDashboard(_ offset: Int = 0, limit: Int = 20, sinceId: Int = 0, containsReblog: Bool = false, containsNotes: Bool = false) {
        
        
        var parameters = [
            "filter" : "clean",
            "reblog_info" : String(true)
        ]
        if offset > 0 {
            parameters["offset"] = String(offset)
        }
        //offset > 0 ? ["offset" : String(offset)] : nil
        TMAPIClient.sharedInstance().posts(self.blogName, type: "", parameters: parameters) { (result, error) in

        //liked_posts
        //TMAPIClient.sharedInstance().likes(parameters) { (result, error) in

            if error != nil {
                return
            }
            
            //begin
            DispatchQueue.global().async {
                
                //Success
                let responseJSON = JSON(result!)
                let postsArray: JSON = responseJSON["posts"]
                
                var tmpLayouts: [TumblrNormalLayout] = []
                if postsArray.type == .array {
                    for postObj in postsArray.arrayValue {
                        let tumblrPost = TumblrPost()
                        tumblrPost.sjMap(postObj)
                        
                        let id = tumblrPost.postId
                        if !self.tmpIDString.contains("\(id),") {
                            let layout = TumblrNormalLayout()
                            layout.fitPostData(tumblrPost)
                            if layout.deleted {
                                self.tmpIDString += "\(id),"
                                continue
                            }
                            tmpLayouts.append(layout)
                            self.tmpIDString += "\(id),"
                        }
                    }
                }

                DispatchQueue.main.async(execute: {
                    if offset > 0 {
                        self.layouts.append(contentsOf: tmpLayouts)
                        self.tableView.reloadData()
                        self.tableView.endLoadingMore()
                    } else {
                        self.layouts = tmpLayouts
                        self.tableView.reloadData()
                        self.tableView.endRefreshing()
                    }
                    self.postsCount += 20
                })
            }
            //end
        }
    }
}

