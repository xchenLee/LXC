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
import MJRefresh
import MBProgressHUD

let kTumblrPostsCell0 = "postCellZero"

class TumblrPosts: UITableViewController {
    
    var layouts: [TumblrNormalLayout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        addDataHandler()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Custom Method
    func addDataHandler() {
        
        self.tableView.addPullDownRefresh {
            self.requestDashboard(0)
        }
        
        self.tableView.addPullUp2LoadMore {
//            guard let firstlayout = self.layouts.last, let firstPost = firstlayout.post else {
//                self.tableView.endLoadingMore()
//                return
//            }
//            let offset = self.layouts.count
            self.requestDashboard(self.layouts.count)
            
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
            return dequeueCell!
        }
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
        
        TMAPIClient.sharedInstance().likes(sinceId > 0 ? ["offset" : String(offset)] : nil) { (result, error) in

        
//        TMAPIClient.sharedInstance().dashboard(sinceId > 0 ? ["offset" : String(offset)] : nil) { (result, error) in
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
                    
                    let layout = TumblrNormalLayout()
                    layout.fitPostData(tumblrPost)
                    tmpLayouts.append(layout)
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
                })
                
                
            })
            
        }
        
        
    }
}



















