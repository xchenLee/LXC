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


class TumblrPostsByTag: UITableViewController {
    
    var layouts: [TumblrNormalLayout] = []
    var tmpIDString: String = ""
    
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

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            let resultJSON = JSON(result)
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

extension TumblrPostsByTag: TumblrNormalCellDelegate {
    
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
        
        let photoView = TumblrPhotoView(photos: post.photos!, currentIndex: index)
        photoView.present((self.navigationController?.view!)!)
    }
    
    func didClickTag(cell: TumblrNormalCell, tag: String) {
        
        
        
//        let storyboard = UIStoryboard(name: kStoryboardNameMain, bundle: NSBundle.mainBundle())
//        let tagsController = storyboard.instantiateViewControllerWithIdentifier("tagscontroller")
//        tagsController.title = tag
//        self.navigationController?.pushViewController(tagsController, animated: true)
        
    }
    
}









