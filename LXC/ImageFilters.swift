//
//  ImageFilters.swift
//  LXC
//
//  Created by renren on 16/3/21.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos

let kSamepleImageName : String = "beauties"

class ImageFilters: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var filteredImageView: ImageFilterView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    
    var filters = [CIFilter]()
    
    var filterDescriptors : [(filterName : String, filterDisplayName : String)] = [
        ("CIColorControls", "None"),
        ("CIPhotoEffectMono", "Mono"),
        ("CIPhotoEffectTonal", "Tonal"),
        ("CIPhotoEffectNoir", "Noir"),
        ("CIPhotoEffectFade", "Fade"),
        ("CISepiaTone", "Film"),
        ("CIPhotoEffectChrome", "Chrome"),
        ("CIPhotoEffectProcess", "Process"),
        ("CIPhotoEffectTransfer", "Transfer"),
        ("CIPhotoEffectInstant", "Instant"),
        ("CIBoxBlur", "Blur"),
        ("CIComicEffect", "Commic"),
        ("CIVignetteEffect", "Vignette"),
        ("CISRGBToneCurveToLinear", "Linear")
    ]
    
    var originalImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        //加载所有支持的滤镜名字
        loadBuiltInFilters()
                
        for descriptor in filterDescriptors {
            if let filter = CIFilter(name: descriptor.filterName) {
                filters.append(filter)
            }
        }
        let sample = UIImage(named: kSamepleImageName)?.fixOrientation()
        
        filteredImageView.contentMode = .scaleAspectFit
        filteredImageView.ciFilter = filters[0]
        filteredImageView.inputImage = sample
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(ImageFilters.saveFilterImg))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        //let gradient = CIFilter(name: "CIVignetteEffect")
        //let properties = gradient?.inputKeys
        //print(properties)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBuiltInFilters() {
        /*builtInFilters = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
        builtInFilters?.insert("CIOriginal", atIndex: 0)
        builtInFilters = [
            "CIOriginal",
            "CIComicEffect",
            "CIColorMonochrome",
            "CIBoxBlur",
            "CIPhotoEffectChrome",
            "CIPhotoEffectFade",
            "CIPhotoEffectInstant",
            "CIPhotoEffectNoir",
            "CIPhotoEffectProcess",
            "CIPhotoEffectTonal",
            "CIPhotoEffectTransfer",
            "CISRGBToneCurveToLinear",
            "CIVignetteEffect",
            "CIColorInvert",
            "CIColorPosterize",
            "CIDotScreen",
            "CIEdges",
            "CIFalseColor",
            "CIUnSharpMask",
            ""
        ]*/
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterDescriptors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! ImageFilterCell
        let filterName = filterDescriptors[indexPath.row].filterDisplayName
        //substringFromIndex(filterName.startIndex.advancedBy(2))
        filterCell.filterNameView.text = filterName
        
        filterCell.filterImageView.contentMode = .scaleAspectFill
        filterCell.filterImageView.inputImage = filteredImageView.inputImage
        filterCell.filterImageView.ciFilter = filters[indexPath.item]
        
        return filterCell;
    }
    
    // MRAK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        filteredImageView.ciFilter = filters[indexPath.row]
        
        /*let filterName = filterDescriptors[indexPath.row].filterDisplayName
        if filterName == "CIOriginal" {
            inputImage.image = originalImage
            return
        }
        
        guard let guardImg = originalImage, cgimg = guardImg.CGImage else {
            print("imageView doesn't have an image!")
            return
        }*/
        
        /*let ciImage = CIImage(image: originalImage!)
        let ciFilter = CIFilter(name: filterName)
        ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        //ciFilter?.setValue(1, forKey: kCIInputIntensityKey)
        ciFilter?.setDefaults()
        
        let ciContext = CIContext(options: nil)
        let outputImg = ciFilter?.outputImage
        
        if outputImg == nil {
            inputImage.image = originalImage
            return
        }
        
        let imageRef = ciContext.createCGImage(outputImg!, fromRect: (outputImg?.extent)!)
        
        let image = UIImage(CGImage: imageRef)
        inputImage.image = image*/
        
        /*let openGLContext = EAGLContext(API: .OpenGLES2)
        let context = CIContext(EAGLContext: openGLContext!, options:[kCIContextUseSoftwareRenderer:true])
        
        let coreImage = CIImage(CGImage: (originalImage?.CGImage)!)
        
        let filter = CIFilter(name: filterName)!
        if filter.inputKeys .contains(kCIInputImageKey) {
            filter.setValue(coreImage, forKey: kCIInputImageKey)
        }
        if filterName == "CIVignetteEffect" {
            filter.setValue(1, forKey: kCIInputIntensityKey)
            filter.setValue(originalImage?.size.height, forKey: kCIInputRadiusKey)
        }
        
        if let exposureOutput = filter.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let output = context.createCGImage(exposureOutput, fromRect: exposureOutput.extent)
            let result = UIImage(CGImage: output)
            inputImage?.image = result
        }*/
    }
    
    func saveFilterImg() {
        
        let imageToSave = filteredImageView.ciFilter.outputImage!
        
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        let finalImage = softwareContext.createCGImage(imageToSave, from: imageToSave.extent)
        let image = UIImage(cgImage: finalImage!)
        
        var assetPlaceHolder : PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            assetPlaceHolder = PHAssetCreationRequest.creationRequestForAsset(from: image).placeholderForCreatedAsset
            }) { (success, error) -> Void in
                
                if success == false {
                    return
                }
                //success
                //self.saveImgToCustomAlbum(assetPlaceHolder!)
        }
    }

    
}











