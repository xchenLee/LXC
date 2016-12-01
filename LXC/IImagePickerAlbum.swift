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
    
    var fetchResults = [PHFetchResult<AnyObject>]()
    var assetCollection = [PHAssetCollection]()
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    
    //MARK: - ViewController life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        let usersAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        
        self.fetchResults = [smartAlbums as! PHFetchResult<AnyObject>, usersAlbums as! PHFetchResult<AnyObject>]
        
        self.fetchAlbums()
        
        PHPhotoLibrary.shared().register(self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Image Picker"
        if ((self.imagePicker?.allowMultipleSelection) != nil) {
            self.navigationItem.setRightBarButton(self.doneBarButton, animated: false)
        } else {
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
            
            fetchResult.enumerateObjects({ (assetCollection, index, stop) -> Void in
                
                let collection = assetCollection as! PHAssetCollection
                let subType = collection.assetCollectionSubtype
                if subType == PHAssetCollectionSubtype.albumRegular {
                    usersAlbums.add(assetCollection)
                    allAlbums.append(collection)
                }
                else if subTypes!.contains(subType) {
                    let key = "\(subType)"
                    if (smartAlbums.object(forKey: key) == nil) {
                        smartAlbums[key] = NSMutableArray()
                    } else {
                        //TODO
                        //TODO
                        //TODO
                        //(smartAlbums[key]).add(assetCollection)
                        allAlbums.append(collection)
                    }
                }
            })
        }
        self.assetCollection.removeAll()
        self.assetCollection.append(contentsOf: allAlbums)
        
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.imagePicker?.delegate?.iImagePickerDidCancel!(self.imagePicker!)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func done(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetCollection.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
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
        
        let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        let imageManager = PHImageManager.default()
        
        if fetchResult.count >= 3 {
            cell.imageViewThr.isHidden = false
            imageManager.requestImage(for: fetchResult[fetchResult.count - 3] , targetSize: cell.imageViewThr.bounds.size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewThr.image = image
                }
            })
        }
        else {
            cell.imageViewThr.isHidden = true
        }
        
        if fetchResult.count >= 2 {
            cell.imageViewTwo.isHidden = false
            imageManager.requestImage(for: fetchResult[fetchResult.count - 2] , targetSize: cell.imageViewTwo.bounds.size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewTwo.image = image
                }
            })
        }
        else {
            cell.imageViewTwo.isHidden = true
        }
        
        
        if fetchResult.count >= 1 {
            cell.imageViewOne.isHidden = false
            imageManager.requestImage(for: fetchResult[fetchResult.count - 1] , targetSize: cell.imageViewOne.bounds.size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (image, info) -> Void in
                if cell.tag == indexPath.row {
                    cell.imageViewOne.image = image
                }
            })
        }
        
        if fetchResult.count == 0 {
            cell.imageViewTwo.isHidden = false
            cell.imageViewThr.isHidden = false
            //TODO place Holder
        }
        cell.photosCount.text = "\(fetchResult.count)"
        cell.albumTitle.text = assetCollection.localizedTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let assetController = segue.destination as! IImagePickerAlbumAssets
        assetController.imagePicker = self.imagePicker
        
        let indexPathRow = self.tableView.indexPathForSelectedRow?.row;
        assetController.assetCollection = self.assetCollection[indexPathRow!]
        
    }
    
    
    //MARK: - PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        var index : Int = 0
        DispatchQueue.main.async { () -> Void in
            
            self.fetchResults.forEach({ (fetchResult) -> () in
                
                let detail = changeInstance.changeDetails(for: fetchResult as! PHFetchResult<PHObject>)
                if detail != nil {
                    let range = (index ..< 1)
                    //self.fetchResults.replaceSubrange(range, with: [detail!.fetchResultAfterChanges])
                }
                index += 1
            })
            
        }
    }
    
    

}









