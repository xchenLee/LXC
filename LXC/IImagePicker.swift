//
//  IImagePicker.swift
//  LXC
//
//  Created by renren on 16/3/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos
import Foundation


// MARK: - IImagePickerDelegate
@objc
protocol IImagePickerDelegate {
    
    @objc optional func iImagePickerDidCancel(_ imagePicker : IImagePicker)

    @objc optional func iImagePicker(_ imagePicker : IImagePicker, didFinishPickingAssets : [PHAsset]);
    @objc optional func iImagePicker(_ imagePicker : IImagePicker, shouldeSelectAsset : PHAsset) -> Bool
    
    @objc optional func iImagePicker(_ imagePicker : IImagePicker, didSelectAsset : PHAsset)
    @objc optional func iImagePicker(_ imagePicker : IImagePicker, didDeSelectAsset : PHAsset)

}

public enum IImagePickerMediaType : Int {
    case any
    case image
    case video
}

// MARK: - IImagePicker
class IImagePicker: UIViewController {
    
    var delegate : IImagePickerDelegate?
    var mediaType : IImagePickerMediaType = IImagePickerMediaType.any
    
    var assetCollectionSubType : [PHAssetCollectionSubtype]?
    
    var allowMultipleSelection : Bool = true
    var minimumNumberOfSelection : Int = 1
    var maximumNumberOfSelection : Int = 9
    
    var numberOfColumnsInPortrait : Int?
    var numberOfColumnsInLandScape : Int?
    
    var selectedAssets : NSMutableOrderedSet?
    
    fileprivate var albumNavigationController : UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Panorama 全景图，全景照片
        // custom
        assetCollectionSubType = [
            PHAssetCollectionSubtype.albumMyPhotoStream,
            .smartAlbumPanoramas,
            .smartAlbumUserLibrary
            //.SmartAlbumVideos,
            //.SmartAlbumBursts
        ]
        
        minimumNumberOfSelection = 1
        maximumNumberOfSelection = 9
        
        numberOfColumnsInPortrait = 4
        numberOfColumnsInLandScape = 7
        
        
                
        selectedAssets = NSMutableOrderedSet()
        
        let navigationController = UIStoryboard(name: "imagepicker", bundle: Bundle.main).instantiateInitialViewController()
            as! UINavigationController
        
        addChildViewController(navigationController)
        navigationController.view.frame = self.view.frame
        self.view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: self)
        
        albumNavigationController = navigationController
        
        
        let albumController = albumNavigationController?.topViewController as! IImagePickerAlbum
        albumController.imagePicker = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
