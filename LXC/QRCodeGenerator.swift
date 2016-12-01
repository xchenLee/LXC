//
//  QRCodeGenerator.swift
//  LXC
//
//  Created by renren on 16/3/19.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos

/**
 
 QRCODE :
    http://www.appcoda.com/qr-code-generator-tutorial/
    
 asset methods example:
    http://stackoverflow.com/questions/27008641/save-images-with-phimagemanager-to-custom-album
 
 assetsLibrary :
    http://stackoverflow.com/questions/4457904/iphone-how-do-i-get-the-file-path-of-an-image-saved-with-uiimagewritetosavedpho?rq=1
 
 */

class QRCodeGenerator: UIViewController, UITextViewDelegate {
    
    let viewPadding : CGFloat = 20
    
    var qrCodeImage : CIImage!
    
    @IBOutlet weak var sourceInputField: UITextView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var generalButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "QR Generator"
        
        //sourceInputField.textContainerInset = UIEdgeInsetsZero
        automaticallyAdjustsScrollViewInsets = false
        
        //let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(QRCodeGenerator.saveQRCode))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func saveQRCode() {
        
        let authorizedStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizedStatus {
        case .authorized:
            saveQRImgToPHotos()
        case .notDetermined:
            NSLog("Not determined")
        case .restricted:
            NSLog("Restricted")
        default:
            return
        }
    }
    
    func saveQRImgToPHotos() {
        
        let imageToSave = qrImageView.image
        
        if imageToSave == nil {
            return
        }

        var assetPlaceHolder : PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            assetPlaceHolder = PHAssetCreationRequest.creationRequestForAsset(from: imageToSave!).placeholderForCreatedAsset
            }) { (success, error) -> Void in
                
                if success == false {
                    return
                }
                //success
                self.saveImgToCustomAlbum(assetPlaceHolder!)
        }
    }
    
    func saveImgToCustomAlbum(_ assetPlaceHolder : PHObjectPlaceholder) {
        
        AppDelegate.getAppDelegate().obtainSystemAssetCollection { (assetCollection) -> Void in
            
            PHPhotoLibrary.shared().performChanges({ () -> Void in
                
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                let assets: NSFastEnumeration = NSArray(array: [assetPlaceHolder])
                albumChangeRequest?.addAssets(assets)
                
                }, completionHandler: { (success, error) -> Void in
                    
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        if text == "\n" {
            sourceInputField.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func generalBtnClicked(_ sender: AnyObject) {
        sourceInputField.resignFirstResponder()
        let inputString = sourceInputField.text
        formQRImage(inputString!)
    }
    
    
    func formQRImage(_ sourceStr : String) {
        if sourceStr.isEmpty {
            qrImageView.image = nil
            return
        }
        let data = sourceStr.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrCodeImage = filter.outputImage
        
        let scaleX = qrImageView.frame.size.width / qrCodeImage.extent.size.width
        let scaleY = qrImageView.frame.size.height / qrCodeImage.extent.size.height
        
        
        let transformedImage = qrCodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        let finalImage = softwareContext.createCGImage(transformedImage, from: transformedImage.extent)
        
        qrImageView.image = UIImage(cgImage: finalImage!)
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











