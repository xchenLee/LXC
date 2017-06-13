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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layouts[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dequeueCell = tableView.dequeueReusableCell(withIdentifier: kTumblrPostsTagCell) as? TumblrNormalCell
        
        let layout = layouts[indexPath.row]
        guard let cell = dequeueCell else {
            dequeueCell = TumblrNormalCell(style: .default, reuseIdentifier: kTumblrPostsCell0)
            dequeueCell?.configLayout(layout)
            dequeueCell?.delegate = self
            return dequeueCell!
        }
        cell.delegate = self
        cell.configLayout(layout)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

// MARK: - extension for cell delegate
extension TumblrPostsList: TumblrNormalCellDelegate {
    
    func didClickAvatar(_ cell: TumblrNormalCell) {
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        let blogName = post.blogName
        
        let blog = TumblrBlog()
        blog.blogHeader = post.headerImage
        blog.blogName = blogName
        if self.parent != nil && self.parent! is TumblrBlog {
            let fatherBlog = self.parent as! TumblrBlog
            if fatherBlog.blogName == blogName {
                self.parent!.shake(3)
                return
            }
        }
        self.navigationController?.pushViewController(blog, animated: true)
    }
    
    func didClickLikeBtn(_ cell: TumblrNormalCell) {
        
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
    
    
    func didClickCopySourceBtn(_ cell: TumblrNormalCell) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let typeString = post.type.lowercased()
        
        if typeString == "video" {
            
            ToolBox.copytoPasteBoard(post.videoUrl)
            //self.showTextHUD("video url copyed to pasteboard")
            return
        }
        
        if typeString == "photo" {
            
            let imageViews = cell.imagesEntry.imageViews
            guard let tmpImageOne = imageViews[0].image else {
                return
            }
            ToolBox.saveImgToSystemAlbum(tmpImageOne)
            //self.showTextHUD("image saved to photos")
        }
        
    }
    
    func didClickImage(_ cell: TumblrNormalCell, index: Int) {
        
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
    
    func didClickTag(_ cell: TumblrNormalCell, tag: String) {
        
        let storyboard = UIStoryboard(name: kStoryboardNameMain, bundle: Bundle.main)
        let tagsController = storyboard.instantiateViewController(withIdentifier: "tagscontroller")
            as! TumblrPostsByTag
        tagsController.tagName = tag
        tagsController.title = tag
        self.navigationController?.pushViewController(tagsController, animated: true)
        
    }
    
    func didClickOuterVideo(_ cell: TumblrNormalCell) {
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let youtubeUrl = post.permalinkUrl
        let url = URL(string: youtubeUrl)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func didLongPressVideo(_ cell: TumblrNormalCell) {
        
        //http://stackoverflow.com/questions/38152763/passing-closures-to-private-apis
        //https://developer.apple.com/videos/play/wwdc2011/406/ 24分钟
        
        guard let layout = cell.layout, let post = layout.post else {
            return
        }
        
        let url = URL(string: post.videoUrl)
        let bounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: layout.videoHeight)
        
        let videoPlayerController = VideoPlayerController(url: url!, bounds: bounds)
        
        self.present(videoPlayerController, animated: true) {
            //会引起闪退
            [weak videoPlayerController] Void in
            
            guard let vp = videoPlayerController else {
                return
            }
            vp.playFromBeginning()
        }
        
    }

}
