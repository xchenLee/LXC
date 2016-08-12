//
//  TumblrImageEntry0.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import YYKit
import Kingfisher

class TumblrImageEntry0: UIView {

    var imageViews: [UIImageView]
    
    var tumblrCell: TumblrNormalCell?
    var cell: TumblrNormalCell?
    
    
    // MARK: - constructors
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        imageViews = []
        for _ in 0...kTMCellMaxPhotoCount {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.whiteColor()
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageViews.append(imageView)
        }
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        imageViews = []
        for _ in 0...kTMCellMaxPhotoCount {
            let imageView = UIImageView()
            imageView.userInteractionEnabled = true
            imageView.backgroundColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0)
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageViews.append(imageView)
        }
        
        
        super.init(frame: frame)
        customInit()
    }
    
    // MARK: - init custom properties and events
    func customInit() {
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        
        for index in 0...kTMCellMaxPhotoCount {
            
            let imageView = self.imageViews[index]
            imageView.tag = kTMCellImageTagPrefix + index
            self.addSubview(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            imageView.addGestureRecognizer(tapGesture)
            
        }
    }
    
    func imageViewTapped(gesture: UITapGestureRecognizer) {
        
        let imageViewIndex = (gesture.view?.tag)! - kTMCellImageTagPrefix
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickImage(safeCell, index: imageViewIndex)
        
    }
    
    // MARK: - fill the component with datas
    func setWithPhotoData(photos: [Photo]?, rects: [CGRect]) {
        
        // no photos, hide all the imageViews
        guard let photoData = photos else {
            
            for imageView in imageViews {
                imageView.hidden = true
            }
            return
        }
        
        // has photos
        
        var photoCount = photoData.count
        if photoCount > kDebugMaxAllowedPhotoCount {
            photoCount = kDebugMaxAllowedPhotoCount
        }
        
        displayImageViews(photoData, rects: rects)
        
        for index in 0..<kTMCellMaxPhotoCount {
            
            let imageView = imageViews[index]
            
            if index >= photoCount {
                imageView.hidden = true
//                imageView.cancelCurrentImageRequest()
                imageView.image = nil
                continue
            }
            
            imageView.hidden = false
            guard let sizes = photoData[index].altSizes else {
                continue
            }
            //0:原图，1:稍微小点
            let properSizePhoto = sizes[1]
            guard let photoUrlString = properSizePhoto.url,
                let photoUrl = NSURL(string: photoUrlString)  else {
                    continue
            }
            imageView.kf_setImageWithURL(photoUrl, placeholderImage: nil, optionsInfo: [KingfisherOptionsInfoItem.Transition(ImageTransition.Fade(0.2))])
        }
        
    }
    
    // MARK: - display images with count
    func displayImageViews(photos: [Photo], rects: [CGRect]) {
        
        var photoCount = photos.count
        if photoCount > kDebugMaxAllowedPhotoCount {
            photoCount = kDebugMaxAllowedPhotoCount
        }
        
        for index in 0..<photoCount {
            
            let imageView = imageViews[index]
            imageView.frame = rects[index]
        }
        
    }
    

}






















