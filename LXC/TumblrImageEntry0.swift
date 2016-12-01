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
    var cell: TumblrNormalCell?
    
    
    // MARK: - constructors
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        imageViews = []
        for _ in 0...kTMCellMaxPhotoCount {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.white
            imageView.contentMode = .scaleAspectFill
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
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageViews.append(imageView)
        }
        
        
        super.init(frame: frame)
        customInit()
    }
    
    // MARK: - init custom properties and events
    func customInit() {
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        
        for index in 0...kTMCellMaxPhotoCount {
            
            let imageView = self.imageViews[index]
            imageView.tag = kTMCellImageTagPrefix + index
            self.addSubview(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            imageView.addGestureRecognizer(tapGesture)
            
        }
    }
    
    func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        
        let imageViewIndex = (gesture.view?.tag)! - kTMCellImageTagPrefix
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickImage(safeCell, index: imageViewIndex)
        
    }
    
    // MARK: - fill the component with datas
    func setWithPhotoData(_ photos: [Photo]?, rects: [CGRect]) {
        
        // no photos, hide all the imageViews
        guard let photoData = photos else {
            
            for imageView in imageViews {
                imageView.isHidden = true
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
                imageView.isHidden = true
//                imageView.cancelCurrentImageRequest()
                imageView.image = nil
                continue
            }
            
            imageView.isHidden = false
            guard let sizes = photoData[index].altSizes else {
                continue
            }
            //0:原图，1:稍微小点
            let properSizePhoto = sizes[1]
            guard let photoUrlString = properSizePhoto.url,
                let photoUrl = URL(string: photoUrlString)  else {
                    continue
            }
            
            let url: URL = URL(string: photoUrlString)!
            imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        
    }
    
    // MARK: - display images with count
    func displayImageViews(_ photos: [Photo], rects: [CGRect]) {
        
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






















