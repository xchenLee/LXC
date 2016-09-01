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
import ObjectMapper
import MediaPlayer
import AVKit

let kTumblrPostsCell0 = "postCellZero"

class TumblrPosts: UITableViewController, UINavigationControllerDelegate {
    
    // MARK: - variables
    var layouts: [TumblrNormalLayout] = []
    var tmpIDString: String = ""
    var postsCount: Int = 0
    
    
    var writeCenter: CGPoint = CGPointZero
    
    lazy var postBtn: UIButton = {
        
        var btn = UIButton(type: UIButtonType.Custom)
        
        let left = kScreenWidth - kTMWriteIconSize * 1.4
        let top = kScreenHeight - kTMWriteIconSize * 1.4
        
        btn.setImage(UIImage(named: "icon_write"), forState: .Normal)
        btn.frame = CGRectMake(left, top, kTMWriteIconSize, kTMWriteIconSize)
        btn.addTarget(self, action: #selector(postBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
    lazy var postBg: UIVisualEffectView = {
    
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    
    func postBtnClick(btn: UIButton) {
        
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
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return layouts[indexPath.row].height
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var dequeueCell = tableView.dequeueReusableCellWithIdentifier(kTumblrPostsCell0) as? TumblrNormalCell
        
        let layout = layouts[indexPath.row]
        guard let cell = dequeueCell else {
            dequeueCell = TumblrNormalCell(style: .Default, reuseIdentifier: kTumblrPostsCell0)
            dequeueCell?.configLayout(layout)
            dequeueCell?.delegate = self
            return dequeueCell!
        }
        cell.delegate = self
        cell.configLayout(layout)

        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        if viewController == self {
            
            UIView.animateWithDuration(0.2, delay: 0.2, options: [.CurveLinear], animations: {
                
                self.postBg.center = self.writeCenter
                self.postBtn.center = self.writeCenter
                
                }, completion: nil)
        } else {
            
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveLinear], animations: {
                
                self.postBg.center = CGPointMake(self.writeCenter.x, kScreenHeight + self.postBtn.size.width)
                self.postBtn.center = CGPointMake(self.writeCenter.x, kScreenHeight + self.postBtn.size.width)
                
                }, completion: nil)
            
        }
    }

}

// MARK: - extension for request datas
extension TumblrPosts {
    
    func requestDashboard(offset: Int = 0, limit: Int = 20, sinceId: Int = 0, containsReblog: Bool = false, containsNotes: Bool = false) {
        
        
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
            let responseJSON = JSON(result)
            let responsePosts = Mapper<ResponsePosts>().map(responseJSON.dictionaryObject!)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                
                guard let posts = responsePosts?.posts else {
                    self.tableView.endRefreshing()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showTextHUD("no posts get")
                    })
                    return
                }
                
                var tmpLayouts: [TumblrNormalLayout] = []
                for tumblrPost in posts {
                    let id = tumblrPost.postId
                    if !self.tmpIDString.containsString("\(id),") {
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    if offset > 0 {
                        self.layouts.appendContentsOf(tmpLayouts)
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

// MARK: - extension for cell delegate
extension TumblrPosts: TumblrNormalCellDelegate {
    
    func didClickLikeBtn(cell: TumblrNormalCell) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let postId = String(post.postId)
        let reblogKey = post.reblogKey
        
        //之前赞过的
        if post.liked {
            TMAPIClient.sharedInstance().unlike(postId, reblogKey: reblogKey, callback: nil)
        } else {
            TMAPIClient.sharedInstance().like(postId, reblogKey: reblogKey, callback: nil)
        }
        
        cell.likeChanged()
        
        
        LayoutManager.doLikeAnimation(cell, liked: post.liked)
    }
    
    
    func didClickCopySourceBtn(cell: TumblrNormalCell) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let typeString = post.type.lowercaseString
        
        if typeString == "video" {
            
            ToolBox.copytoPasteBoard(post.videoUrl)
            print(UIPasteboard.generalPasteboard().string)
            self.showTextHUD("video url copyed to pasteboard")
            return
        }
        
        
        if typeString == "photo" {
            
            let imageViews = cell.imagesEntry.imageViews
            guard let tmpImageOne = imageViews[0].image else {
                return
            }
            ToolBox.saveImgToSystemAlbum(tmpImageOne)
            self.showTextHUD("image saved to photos")
        }
        
    }
    
    func didClickImage(cell: TumblrNormalCell, index: Int) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        let clickedImageView = cell.imagesEntry.imageViews[index]
        
        let photos = post.photos!
        
        var previewItems: [TumblrPhotoPreviewItem] = []
        
        for i in 0..<photos.count {
            let item = TumblrPhotoPreviewItem()
            item.photo = photos[i]
            item.thumView = cell.imagesEntry.imageViews[i]
            previewItems.append(item)
        }
        
        
        let photoView = TumblrPhotoView(photos: previewItems, currentIndex: index)
        photoView.preset(clickedImageView, index: index, container: (self.navigationController?.view!)!)
    }
    
    func didClickTag(cell: TumblrNormalCell, tag: String) {
        
        let storyboard = UIStoryboard(name: kStoryboardNameMain, bundle: NSBundle.mainBundle())
        let tagsController = storyboard.instantiateViewControllerWithIdentifier("tagscontroller")
            as! TumblrPostsByTag
        tagsController.tagName = tag
        tagsController.title = tag
        self.navigationController?.pushViewController(tagsController, animated: true)

    }
    
    func didClickOuterVideo(cell: TumblrNormalCell) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let youtubeUrl = post.permalinkUrl
        let url = NSURL(string: youtubeUrl)
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    func didLongPressVideo(cell: TumblrNormalCell) {
        
        //http://stackoverflow.com/questions/38152763/passing-closures-to-private-apis
       
        //https://developer.apple.com/videos/play/wwdc2011/406/ 24分钟
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let url = NSURL(string: post.videoUrl)
        let bounds = CGRectMake(0, 0, kScreenWidth, layout.videoHeight)
        
        let videoPlayerController = VideoPlayerController(url: url!, bounds: bounds)
        
        self.presentViewController(videoPlayerController, animated: true) {
            //会引起闪退
            //videoPlayerController.playFromBeginning()
        }
    
    }
    
}
