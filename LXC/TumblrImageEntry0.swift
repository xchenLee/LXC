//
//  TumblrImageEntry0.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Kingfisher

class TumblrImageEntry0: UIView {

    var imageViews: [UIImageView]
    
    var tumblrCell: TumblrNormalCell?
    
    
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
            imageViews.append(imageView)
        }
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        imageViews = []
        for _ in 0...kTMCellMaxPhotoCount {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.whiteColor()
            imageView.contentMode = .ScaleAspectFill
            imageViews.append(imageView)
        }
        
        
        super.init(frame: frame)
        customInit()
    }
    
    // MARK: - init custom properties and events
    func customInit() {
        
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        
        for index in 0...kTMCellMaxPhotoCount {
            
            let imageView = self.imageViews[index]
            imageView.tag = kTMCellImageTagPrefix + index
            self.addSubview(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "imageViewTapped")
            imageView.addGestureRecognizer(tapGesture)
            
        }
    }
    
    func imageViewTapped(gesture: UITapGestureRecognizer) {
        
        let imageViewIndex = (gesture.view?.tag)! - kTMCellImageTagPrefix
        
    }
    
    // MARK: - fill the component with datas
    func setWithPhotoData(photos: [Photo]?) {
        
        // no photos, hide all the imageViews
        guard let photoData = photos else {
            
            for imageView in imageViews {
                imageView.hidden = true
            }
            return
        }
        
        // has photos
        let photoCount = photoData.count
        for index in 0...kTMCellMaxPhotoCount {
            
            let imageView = imageViews[index]
            
            if index >= photoCount {
                imageView.hidden = true
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
            imageView.kf_setImageWithURL(photoUrl)
        }
        displayImageViews(photoData)
        
    }
    
    // MARK: - display images with count
    func displayImageViews(photos: [Photo]) {
        
        let photoCount = photos.count
        switch photoCount {
        case 1:
            
            let imageView = imageViews.first
            imageView?.frame = self.bounds
            break
            
        case 2:
            
            let photo0 = photos[0]
            let photo1 = photos[1]

            let imageView0 = imageViews[0]
            let imageView1 = imageViews[1]
            
            
            
            
        default:
            break
        }
        
    }
    

}






















