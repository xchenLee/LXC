//
//  IImagePickerAlbum.swift
//  LXC
//
//  Created by renren on 16/3/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos

class IImagePickerAlbum: UITableViewController, PHPhotoLibraryChangeObserver {
    
    var imagePicker : IImagePicker?
    
    var fetchResults = [PHFetchResult]()
    var assetCollection = [PHAssetCollection]()
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    
    //MARK: - ViewController life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.Any, options: nil)
        
        let usersAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.Any, options: nil)
        
        self.fetchResults = [smartAlbums, usersAlbums]
        
        self.fetchAlbums()
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        var array = [0,1,2,3,4]
        
        let range = Range(start: 2, end: 1)
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Image Picker"
        if ((self.imagePicker?.allowMultipleSelection) != nil) {
            self.navigationItem.setRightBarButtonItem(self.doneBarButton, animated: false)
        } else {
            self.navigationItem.setRightBarButtonItem(nil, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    
    // MARK: - Custom Method
    func fetchAlbums() {
        let subTypes = self.imagePicker?.assetCollectionSubType
        // smart  字典
        let smartAlbums = NSMutableDictionary()
        // users  数组
        let usersAlbums = NSMutableArray()
        
        var allAlbums = [PHAssetCollection]()
        
        for fetchResult in self.fetchResults {
            
            fetchResult.enumerateObjectsUsingBlock({ (assetCollection, index, stop) -> Void in
                
                let collection = assetCollection as! PHAssetCollection
                let subType = collection.assetCollectionSubtype
                if subType == PHAssetCollectionSubtype.AlbumRegular {
                    usersAlbums.addObject(assetCollection)
                    allAlbums.append(collection)
                }
                else if subTypes!.contains(subType) {
                    let key = "\(subType)"
                    if (smartAlbums.objectForKey(key) == nil) {
                        smartAlbums[key] = NSMutableArray()
                    } else {
                        smartAlbums[key]?.addObject(assetCollection)
                        allAlbums.append(collection)
                    }
                }
            })
        }
        self.assetCollection.removeAll()
        self.assetCollection.appendContentsOf(allAlbums)
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.imagePicker?.delegate?.iImagePickerDidCancel!(self.imagePicker!)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func done(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetCollection.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath)
        as! IImageAlbumCell
        cell.tag = indexPath.row
        
        let assetCollection = self.assetCollection[indexPath.row]
        
        /*let fetchOptions = PHFetchOptions()
        
        switch self.imagePicker?.mediaType {
        case IImagePickerMediaType.Image:
            fetchOptions.predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.Image)")
        case IImagePickerMediaType.Video:
            fetchOptions.predicate = NSPredicate(format: "mediaType = \(PHAssetMediaType.Video)")
        }*/
        
        let fetchResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
        let imageManager = PHImageManager.defaultManager()
        
        if fetchResult.count >= 3 {
            cell.imageViewThr.hidden = false
            imageManager.requestImageForAsset(fetchResult[fetchResult.count - 3] as! PHAsset, targetSize: cell.imageViewThr.bounds.size, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewThr.image = image
                }
            })
        }
        else {
            cell.imageViewThr.hidden = true
        }
        
        if fetchResult.count >= 2 {
            cell.imageViewTwo.hidden = false
            imageManager.requestImageForAsset(fetchResult[fetchResult.count - 2] as! PHAsset, targetSize: cell.imageViewTwo.bounds.size, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewTwo.image = image
                }
            })
        }
        else {
            cell.imageViewTwo.hidden = true
        }
        
        
        if fetchResult.count >= 1 {
            cell.imageViewOne.hidden = false
            imageManager.requestImageForAsset(fetchResult[fetchResult.count - 1] as! PHAsset, targetSize: cell.imageViewOne.bounds.size, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewOne.image = image
                }
            })
        }
        
        if fetchResult.count == 0 {
            cell.imageViewTwo.hidden = false
            cell.imageViewThr.hidden = false
            //TODO place Holder
        }
        cell.photosCount.text = "\(fetchResult.count)"
        cell.albumTitle.text = assetCollection.localizedTitle
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let assetController = segue.destinationViewController as! IImagePickerAlbumAssets
        assetController.imagePicker = self.imagePicker
        
        let indexPathRow = self.tableView.indexPathForSelectedRow?.row;
        assetController.assetCollection = self.assetCollection[indexPathRow!]
        
    }
    
    
    //MARK: - PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange) {
        
        var index : Int = 0
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.fetchResults.forEach({ (fetchResult) -> () in
                
                let detail = changeInstance.changeDetailsForFetchResult(fetchResult)
                if detail != nil {
                    let range = Range(start: index, end: 1)
                    self.fetchResults.replaceRange(range, with: [detail!.fetchResultAfterChanges])
                }
                index += 1
            })
            
        }
    }
    
    

}









