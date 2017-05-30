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
    
    
    var writeCenter: CGPoint = CGPoint.zero
    
    lazy var postBtn: UIButton = {
        
        var btn = UIButton(type: UIButtonType.custom)
        
        let left = kScreenWidth - kTMWriteIconSize * 1.4
        let top = kScreenHeight - kTMWriteIconSize * 1.4
        
        btn.setImage(UIImage(named: "icon_write"), for: UIControlState())
        btn.frame = CGRect(x: left, y: top, width: kTMWriteIconSize, height: kTMWriteIconSize)
        btn.addTarget(self, action: #selector(postBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    
    lazy var postBg: UIVisualEffectView = {
    
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = kTMWriteIconSize / 2
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDataHandler()
        self.tableView.mj_header.beginRefreshing()
        
        self.navigationController?.view.addSubview(self.postBg)
        self.postBg.frame = self.postBtn.frame
        
        
        self.navigationController?.view.addSubview(self.postBtn)
        self.writeCenter = self.postBtn.center


        self.navigationController?.delegate = self
        
        let fpsLabel = FPSLabel()
        fpsLabel.frame = CGRect(x: 10, y: kScreenHeight - 20, width: 65, height: 25)
        self.navigationController?.view.addSubview(fpsLabel)
        
    }
    
    // MARK: - Custom Method
    
    func postBtnClick(_ btn: UIButton) {
        
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
        
        if viewController == self {
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveLinear], animations: {
                
                self.postBg.center = self.writeCenter
                self.postBtn.center = self.writeCenter
                
                }, completion: nil)
        } else {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                
                self.postBg.center = CGPoint(x: self.writeCenter.x, y: kScreenHeight + self.postBtn.size.width)
                self.postBtn.center = CGPoint(x: self.writeCenter.x, y: kScreenHeight + self.postBtn.size.width)
                
                }, completion: nil)
            
        }
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
        TMAPIClient.sharedInstance().likes(parameters) { (result, error) in

            if error != nil {
                return
            }
            
            //Success
            let responseJSON = JSON(result!)
            let postsArray: JSON = responseJSON["liked_posts"]
            
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

            DispatchQueue.global().async {

                
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
            
        }
    }
}

