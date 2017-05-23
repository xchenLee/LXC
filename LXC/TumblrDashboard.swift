//
//  TumblrDashboard.swift
//  LXC
//
//  Created by renren on 16/9/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK
import SwiftyJSON
import ObjectMapper

class TumblrDashboard: TumblrPostsList, UINavigationControllerDelegate {
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDataHandler()
        self.tableView.mj_header.beginRefreshing()
        
        let navRightImg = UIImage(named: "icon_write")
        let navRightBtn = UIBarButtonItem(image: navRightImg, style: .plain, target: self, action: #selector(postBtnClick))
        self.navigationItem.rightBarButtonItem = navRightBtn
        
        self.navigationController?.delegate = self
        
        let fpsLabel = FPSLabel()
        fpsLabel.frame = CGRect(x: 10, y: kScreenHeight - 20, width: 65, height: 25)
        self.navigationController?.view.addSubview(fpsLabel)
        
    }
    
    // MARK: - Custom Method
    
    func postBtnClick(_ btn: UIButton) {
        
        let board = PostBoard(frame: UIScreen.main.bounds)
        self.navigationController?.view.addSubview(board)
    
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
        
        //TODO 做一些操作
        if viewController == self {
        } else {
        }
    }
    
}

// MARK: - extension for request datas
extension TumblrDashboard {
    
    func requestDashboard(_ offset: Int = 0, limit: Int = 20, sinceId: Int = 0, containsReblog: Bool = false, containsNotes: Bool = false) {
        
        
        var parameters = [
            "filter" : "clean",
            "reblog_info" : String(true)
        ]
        if offset > 0 {
            parameters["offset"] = String(offset)
        }
        //offset > 0 ? ["offset" : String(offset)] : nil
        TMAPIClient.sharedInstance().likes(parameters) { (result, error) in
            
            
            //        TMAPIClient.sharedInstance().dashboard(offset > 0 ? ["offset" : String(offset)] : nil) { (result, error) in
            if error != nil {
                return
            }
            
            //Success
            let responseJSON = JSON(result!)
            let responsePosts = Mapper<ResponsePosts>().map(JSON: responseJSON.dictionaryObject!)
            
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                
                guard let posts = responsePosts?.posts else {
                    self.tableView.endRefreshing()
//                    DispatchQueue.main.async(execute: {
//                    })
                    return
                }
                
                var tmpLayouts: [TumblrNormalLayout] = []
                for tumblrPost in posts {
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
                
                
            })
            
        }
    }
}
