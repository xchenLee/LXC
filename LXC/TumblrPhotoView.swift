//
//  TumblrPhotoView.swift
//  LXC
//
//  Created by renren on 16/8/7.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kTumblrPhotoViewAnimationDuration: NSTimeInterval = 0.3

class TumblrPhotoView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var photoDatas: [TumblrPhotoPreviewItem] = []
    var currentIndex: Int = 0
    var blurBackground: Bool = true
    
    private var background: UIImageView
    private var scrollView: UIScrollView
    private var photoCells: [TumblrPhotoCell] = []
    
    private var fromView: UIImageView!
    private var fromViewIndex: NSInteger!
    
    // MARK: - 初始化方法
    init(photos: [TumblrPhotoPreviewItem], currentIndex: Int) {
        
        self.scrollView = UIScrollView()
        self.background = UIImageView()
        self.photoDatas = photos
        self.currentIndex = currentIndex
        super.init(frame: UIScreen.mainScreen().bounds)
        customInit()
    }
    
    // MARK: - Constructors
    required init?(coder aDecoder: NSCoder) {
        
        self.scrollView = UIScrollView()
        self.background = UIImageView()
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        self.scrollView = UIScrollView()
        self.background = UIImageView()
        super.init(frame: frame)
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        //self.backgroundColor = UIColor.fromARGB(0x000000, alpha: 0.7)
        self.frame = UIScreen.mainScreen().bounds
        
        self.background.frame = self.bounds
        self.addSubview(self.background)
        
        self.scrollView.frame = self.bounds
        self.scrollView.delegate = self
        self.scrollView.scrollsToTop = false
        self.scrollView.pagingEnabled = true
        self.scrollView.userInteractionEnabled = true
        
        self.scrollView.alwaysBounceHorizontal = self.photoDatas.count > 1
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollView.delaysContentTouches = false
        self.scrollView.canCancelContentTouches = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        let duobleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        duobleTapGesture.numberOfTapsRequired = 2
        duobleTapGesture.delegate = self
        duobleTapGesture.requireGestureRecognizerToFail(tapGesture)
        self.addGestureRecognizer(duobleTapGesture)
        
        self.addSubview(self.scrollView)
        
        let count = self.photoDatas.count
        
        for index in 0..<count {
            
            let photoCell = TumblrPhotoCell()
            photoCell.cellIndex = index
            photoCell.frame = self.bounds
            photoCell.frame.origin.x = CGFloat(index) * kScreenWidth
            photoCell.containerView.frame = photoCell.bounds
            photoCells.append(photoCell)
            self.scrollView.addSubview(photoCell)
        }
    }
    
    func singleTapAction(gesture: UITapGestureRecognizer) {
        self.dimiss()
    }
    
    func doubleTapAction(gesture: UITapGestureRecognizer) {
        
    }
    
    // MARK: - Self methods
    func cellForPage(index: NSInteger) -> TumblrPhotoCell? {
        
        for photoCell in photoCells {
            if photoCell.cellIndex == index {
                return photoCell
            }
        }
        return nil
    }
    
    // MARK: - 显示
    func preset(fromView: UIImageView, index: NSInteger, container: UIView) {
        
        self.fromView = fromView
        self.fromViewIndex = index
        //let snapshot = container.snapshotImageAfterScreenUpdates(false)
        //fromView.hidden = true
        //fromView.hidden = false
        //self.background.image = snapshot
        
        
        container.addSubview(self)
        
        let count = self.photoDatas.count
        self.scrollView.contentSize = CGSizeMake(CGFloat(count) * kScreenWidth, kScreenHeight)
        let currentRect = CGRectMake(kScreenWidth * CGFloat(currentIndex), 0, kScreenWidth, kScreenHeight)
        self.scrollView.scrollRectToVisible(currentRect, animated: false)
        self.scrollViewDidScroll(self.scrollView)
        
        let imageCell = photoCells[index]
        
        let fromRect = fromView.convertRect(fromView.bounds, toView: imageCell.containerView)
        
        imageCell.containerView.clipsToBounds = false
        imageCell.imageView.frame = fromRect
        imageCell.contentMode = .ScaleAspectFill
        
        self.scrollView.userInteractionEnabled = false
        
        UIView.animateWithDuration(kTumblrPhotoViewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
            imageCell.imageView.frame = imageCell.containerView.bounds
            }) { (finished) in
                
                UIView.animateWithDuration(kTumblrPhotoViewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
                    imageCell.containerView.clipsToBounds = true
                    self.scrollViewDidScroll(self.scrollView)
                    self.scrollView.userInteractionEnabled = true
                    }, completion: { (finish) in
                })
                
        }
    }
    
    func dimiss() {
        
        let photoCell = self.cellForPage(self.currentIndex)
        let photoData = self.photoDatas[self.currentIndex]
        
        var fromView = self.fromView
        if self.currentIndex != self.fromViewIndex {
            fromView = photoData.thumView
        }
        
        UIView.animateWithDuration(kTumblrPhotoViewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
            
            let fromRect = fromView.convertRect(fromView.bounds, toView: photoCell?.containerView)
            photoCell?.containerView.clipsToBounds = false
            photoCell?.contentMode = fromView.contentMode
            photoCell?.imageView.frame = fromRect
            
        }) { (finished) in
            UIView.animateWithDuration(0.15, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
                self.alpha = 0
                }, completion: { (finish) in
                    self.removeFromSuperview()
            })
            
        }
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.width))
        var indexes: [Int] = [page]
        if page - 1 >= 0 {
            indexes.append((page - 1))
        }
        if page + 1 <= self.photoCells.count - 1 {
            indexes.append((page + 1))
        }
        
        for index in indexes {
            let photoData = photoDatas[index]
            let photoCell = photoCells[index]
            photoCell.fitPhotoData(photoData)
        }
        self.currentIndex = page
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    // MARK: - UIGestureRecognizerDelegate

}

class TumblrPhotoPreviewItem: NSObject {
    
    var photo: Photo!
    var thumView: UIImageView!
}



















