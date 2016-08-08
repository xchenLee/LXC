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

let kTumblrPostsCell0 = "postCellZero"

class TumblrPosts: UITableViewController {
    
    var layouts: [TumblrNormalLayout] = []
    var tmpIDString: String = ""
    var postsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        addDataHandler()
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Custom Method
    func addDataHandler() {
        
        self.tableView.addPullDownRefresh {
            self.postsCount = 0
            self.tmpIDString = ""
            self.requestDashboard(0)
        }
        
        self.tableView.addPullUp2LoadMore {
            guard let firstlayout = self.layouts.last, let lastPost = firstlayout.post else {
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
        //let cell = tableView.dequeueReusableCellWithIdentifier(kTumblrPostsCell0, forIndexPath: indexPath)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

extension TumblrPosts {
    
    func requestDashboard(offset: Int = 0, limit: Int = 20, sinceId: Int = 0, containsReblog: Bool = false, containsNotes: Bool = false) {
        
        TMAPIClient.sharedInstance().likes(offset > 0 ? ["offset" : String(offset)] : nil) { (result, error) in

        
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
//                    dispatch_async(dispatch_get_main_queue(), { 
//                    })
                    return
                }
                
                var tmpLayouts: [TumblrNormalLayout] = []
                for tumblrPost in posts {
                    let id = tumblrPost.postId
                    if !self.tmpIDString.containsString("\(id),") {
                        let layout = TumblrNormalLayout()
                        layout.fitPostData(tumblrPost)
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
        
        //找到相对于Window的frame，开始做动画

        let window = UIApplication.sharedApplication().delegate?.window!
        let likeBtn = cell.toolBarEntry.likeBtn
        let frameInCell = cell.toolBarEntry.convertRect(likeBtn.frame, toView: cell.contentView)
        let frameInWindow = cell.convertRect(frameInCell, toView: window)
        
        let size = frameInWindow.width
        
        //如果现在是喜欢的状态
        if post.liked {
            let animatedHeart = UIImageView()
            animatedHeart.size = CGSizeMake(48, 48)
            animatedHeart.contentMode = .ScaleAspectFill
            animatedHeart.image = UIImage(named: "icon_animated_like")
            animatedHeart.frame = frameInWindow
            animatedHeart.alpha = 0.6
            animatedHeart.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 9))
            animatedHeart.transform = CGAffineTransformScale(animatedHeart.transform, 0.75, 0.75)
            window?.addSubview(animatedHeart)
            
            let center = animatedHeart.center
            
            UIView.animateKeyframesWithDuration(0.7, delay: 0, options: [.CalculationModeLinear], animations: {
                
                UIView .addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: {
                    animatedHeart.alpha = 1.0
                    animatedHeart.transform = CGAffineTransformScale(animatedHeart.transform, 4/3.0, 4/3.0)
                    animatedHeart.center = CGPointMake(center.x - size * 0.1, center.y - size * 0.5)
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.5, animations: {
                    animatedHeart.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 8))
                    animatedHeart.center = CGPointMake(center.x, center.y - size * 1.8)
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.6, animations: {
                    animatedHeart.center = CGPointMake(center.x + size * 0.2, center.y - size * 2.6)
                    
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.7, animations: {
                    animatedHeart.alpha = 0.3
                })
                
            }) { (finish) in
                animatedHeart.removeFromSuperview()
                
            }
            return
        }
        
        let centerX = frameInWindow.origin.x + size * 0.5
        
        let breakupTop = frameInWindow.origin.y - 2.5 * size
        let leftLeft = centerX - 28 + 5
        let rightLeft = centerX - 5
        
        //做不喜欢的动画
        let animatedLeft = UIImageView()
        animatedLeft.size = CGSizeMake(28, 48)
        animatedLeft.contentMode = .ScaleAspectFill
        animatedLeft.image = UIImage(named: "icon_animated_unlike_left")
        animatedLeft.frame = CGRectMake(leftLeft, breakupTop, 28, 48)
        window?.addSubview(animatedLeft)
        
        
        let animatedRight = UIImageView()
        animatedRight.size = CGSizeMake(28, 48)
        animatedRight.contentMode = .ScaleAspectFill
        animatedRight.image = UIImage(named: "icon_animated_unlike_right")
        animatedRight.frame = CGRectMake(rightLeft, breakupTop-1, 28, 48)
        window?.addSubview(animatedRight)
        
        let centerLeft = animatedLeft.center
        let centerRight = animatedRight.center
        
        
        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: [.CalculationModeLinear], animations: {
            
            UIView .addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3, animations: {
                
                animatedLeft.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 16))
                animatedLeft.center = CGPointMake(centerLeft.x - 12, centerLeft.y)
                
                animatedRight.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 16))
                animatedRight.center = CGPointMake(centerRight.x + 12, centerRight.y)

            })
            
            UIView .addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.7, animations: {
                
                animatedLeft.center = CGPointMake(centerLeft.x - 12, centerLeft.y + 2 * size)
                animatedLeft.alpha = 0.0
                animatedRight.center = CGPointMake(centerRight.x + 12, centerRight.y + 2 * size)
                animatedRight.alpha = 0.0

            })
            
            
        }) { (finish) in
            animatedLeft.removeFromSuperview()
            animatedRight.removeFromSuperview()
            
        }

        
        
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
    
}


