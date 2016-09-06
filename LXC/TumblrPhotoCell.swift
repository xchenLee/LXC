//
//  TumblrPhotoCell.swift
//  LXC
//
//  Created by renren on 16/8/7.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrPhotoCell: UIScrollView, UIScrollViewDelegate {

    var containerView: UIView
    var imageView: UIImageView
    var cellIndex: Int = 0
    var photo: TumblrPhotoPreviewItem?
        
    
    // MARK: - Constructors
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.containerView = UIView()
        self.containerView.clipsToBounds = true
        
        self.imageView = UIImageView()
        self.imageView.clipsToBounds = true
        
        super.init(coder: aDecoder)
        customInit()
    }
    override init(frame: CGRect) {
        
        self.containerView = UIView()
        self.containerView.clipsToBounds = true
        self.imageView = UIImageView()
        self.imageView.clipsToBounds = true
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.userInteractionEnabled = true
        self.frame = UIScreen.mainScreen().bounds
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = false
        self.multipleTouchEnabled = true
        
        self.containerView.userInteractionEnabled = true
        self.imageView.userInteractionEnabled = true
        
        self.bouncesZoom = true
        self.maximumZoomScale = 2
        
        self.delegate = self
        
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
    
    }
    
    // MARK: - setDatas and resize
    func fitPhotoData(photoData: TumblrPhotoPreviewItem) {
        //如果图片数据一样，因为不是 NSObject，无法比较，只能比较JSON
        if self.photo != nil && self.photo!.photo.toJSONString() == photoData.photo.toJSONString() {
            return
        }
        
        self.photo = photoData
        self.setZoomScale(1.0, animated: false)
        self.maximumZoomScale = 1
        
        //TODO Progress
        let urlString = photoData.photo.originalSize!.url!
        let photoUrl = NSURL(string: urlString)
        
        //先用缓存数据
        imageView.image = photoData.thumView.image
        
        imageView.kf_setImageWithURL(photoUrl!, placeholderImage: nil, optionsInfo: [], progressBlock: { (receivedSize, totalSize) in
            }) { (image, error, cacheType, imageURL) in
                self.maximumZoomScale = 2
                
        }
        
        self.resizeSubViews()
    }
    
    
    func resizeSubViews() {
        self.containerView.origin = CGPointZero
        self.containerView.width = self.bounds.size.width
        
        //矫正尺寸
        let photoSize = self.photo!.photo.originalSize!
        var photoWidth = CGFloat(photoSize.width)
        if photoWidth == 0 {
            photoWidth = kScreenWidth
        }
        var photoHeight = CGFloat(photoSize.height)
        if photoHeight == 0 {
            photoHeight = kScreenWidth
        }
        //不管图片是长图还是宽图，都以屏幕宽度为最大限度，
        let height = photoHeight / photoWidth * self.width
        containerView.height = floor(height)
        //这个算法如果图片过长了，就从0，0开始显示，如果不是，就在中间显示
        if photoHeight /  photoWidth <= self.height / self.width {
            
            containerView.centerY = self.height / 2
        }
        
        //如果图片长，但是差值很小，就过滤掉
        if containerView.height > self.height && containerView.height - self.height < 1 {
            containerView.height = self.height
        }
        
        self.contentSize = CGSizeMake(self.width, max(containerView.height, self.height));
        self.scrollRectToVisible(self.bounds, animated: false)
        
        //如果图片高度大于自身高度可以bounce vertical
        self.alwaysBounceVertical = containerView.height > self.height
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        imageView.frame = containerView.bounds
        CATransaction.commit()
    }
    
    
    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        let containerView = self.containerView
        
        var offsetX: CGFloat = 0
        if scrollView.bounds.size.width > scrollView.contentSize.width {
            offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) / 2
        }
        
        var offsetY: CGFloat = 0
        if scrollView.bounds.size.height > scrollView.contentSize.height {
            offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) / 2
        }
        
        containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY)
        
    }

}

