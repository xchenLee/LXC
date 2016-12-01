//
//  IImagePickerAlbumAssets.swift
//  LXC
//
//  Created by renren on 16/3/28.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "albumAssetCell"
private let cellSpace : Int = 2

class IImagePickerAlbumAssets: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    
    var imagePicker : IImagePicker?
    var assetCollection : PHAssetCollection?
    
    var fetchResult :PHFetchResult<PHAsset>?
    
    var catchingManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView?.allowsMultipleSelection = (self.imagePicker?.allowMultipleSelection)!
        
        self.updateFetchAssets()
        self.collectionView?.reloadData()
        // Do any additional setup after loading the view.
        
        //check 3D Touch before using it
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
        else {
            //TODO  if use long Press
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.assetCollection?.localizedTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom methods
    func updateFetchAssets() {
        if self.assetCollection == nil {
            return
        }
        
        self.fetchResult = PHAsset.fetchAssets(in: self.assetCollection!, options: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (fetchResult?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IImageAlbumAssetCell
        cell.tag = indexPath.item
        
        let asset = fetchResult![indexPath.row] as! PHAsset
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let size = flowLayout.itemSize
        
        self.catchingManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (assetImage, info) -> Void in
            
            if cell.tag == indexPath.item {
                cell.assetImageView.image = assetImage
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns : Int = 0;
        let portrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        numberOfColumns = (portrait ? self.imagePicker?.numberOfColumnsInPortrait : self.imagePicker?.numberOfColumnsInLandScape)!
        
        let width = (Int(self.view.frame.width) - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        let floatW = CGFloat(width)
        return CGSize(width: floatW, height: floatW)
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let convertPoint = self.collectionView!.convert(location, from: self.view)
        if let indexPath = self.collectionView?.indexPathForItem(at: convertPoint), let attributes = collectionView?.layoutAttributesForItem(at: indexPath) {
            
            let convertRect = self.collectionView?.convert(attributes.frame, to: self.view)
            previewingContext.sourceRect = convertRect!
            return buildPreviewController(indexPath)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    func buildPreviewController(_ indexPath : IndexPath) -> UIViewController {
        
        let pop = IImagePickerAssetPop()
        
        let imageView = pop.assetDisplayView
        
        let asset = fetchResult![indexPath.row] as! PHAsset
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        
        let sizeWanted = getScaledSize(asset.pixelWidth, height: asset.pixelHeight)
        
        self.catchingManager.requestImage(for: asset, targetSize: sizeWanted, contentMode: .aspectFill, options: options) { (assetImage, info) -> Void in
            imageView.image = assetImage
        }
        pop.preferredContentSize = sizeWanted
        return pop
    }
    
    func getScaledSize(_ width : Int, height : Int) -> CGSize {
        
        var finalW : CGFloat = 0
        var finalH : CGFloat = 0
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        let radioScreen = screenW / screenH
        
        let radioCompare = CGFloat(width) / CGFloat(height)
        
        if radioCompare > radioScreen {
            finalW = screenW
            finalH = finalW / CGFloat(width) * CGFloat(height)
        }
        else {
            finalH = screenH
            finalW = finalH / CGFloat(height) * CGFloat(width)
        }
        
        return CGSize(width: finalW, height: finalH)
    }

}

















