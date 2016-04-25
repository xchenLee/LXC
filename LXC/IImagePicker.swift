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
    
    optional func iImagePickerDidCancel(imagePicker : IImagePicker)

    optional func iImagePicker(imagePicker : IImagePicker, didFinishPickingAssets : [PHAsset]);
    optional func iImagePicker(imagePicker : IImagePicker, shouldeSelectAsset : PHAsset) -> Bool
    
    optional func iImagePicker(imagePicker : IImagePicker, didSelectAsset : PHAsset)
    optional func iImagePicker(imagePicker : IImagePicker, didDeSelectAsset : PHAsset)

}

public enum IImagePickerMediaType : Int {
    case Any
    case Image
    case Video
}

// MARK: - IImagePicker
class IImagePicker: UIViewController {
    
    var delegate : IImagePickerDelegate?
    var mediaType : IImagePickerMediaType = IImagePickerMediaType.Any
    
    var assetCollectionSubType : [PHAssetCollectionSubtype]?
    
    var allowMultipleSelection : Bool = true
    var minimumNumberOfSelection : Int = 1
    var maximumNumberOfSelection : Int = 9
    
    var numberOfColumnsInPortrait : Int?
    var numberOfColumnsInLandScape : Int?
    
    var selectedAssets : NSMutableOrderedSet?
    
    private var albumNavigationController : UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Panorama 全景图，全景照片
        // custom
        assetCollectionSubType = [
            PHAssetCollectionSubtype.AlbumMyPhotoStream,
            .SmartAlbumPanoramas,
            .SmartAlbumUserLibrary
            //.SmartAlbumVideos,
            //.SmartAlbumBursts
        ]
        
        minimumNumberOfSelection = 1
        maximumNumberOfSelection = 9
        
        numberOfColumnsInPortrait = 4
        numberOfColumnsInLandScape = 7
        
        
                
        selectedAssets = NSMutableOrderedSet()
        
        let navigationController = UIStoryboard(name: "imagepicker", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
            as! UINavigationController
        
        addChildViewController(navigationController)
        navigationController.view.frame = self.view.frame
        self.view.addSubview(navigationController.view)
        navigationController.didMoveToParentViewController(self)
        
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
