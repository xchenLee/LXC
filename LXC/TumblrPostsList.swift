//
//  TumblrPostsList.swift
//  LXC
//
//  Created by renren on 16/9/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK
import SwiftyJSON
import AVKit



let kTumblrPostsCell0: String = "kTumblrPostsCell0"

class TumblrPostsList: UITableViewController {

    // MARK: - variables
    var layouts: [TumblrNormalLayout] = []
    var tmpIDString: String = ""
    var postsCount: Int = 0
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        var dequeueCell = tableView.dequeueReusableCellWithIdentifier(kTumblrPostsTagCell) as? TumblrNormalCell
        
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
    
}

// MARK: - extension for cell delegate
extension TumblrPostsList: TumblrNormalCellDelegate {
    
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
            [weak videoPlayerController] Void in
            
            guard let vp = videoPlayerController else {
                return
            }
            vp.playFromBeginning()
        }
        
    }

}
