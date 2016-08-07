//
//  TumblrPhotoView.swift
//  LXC
//
//  Created by renren on 16/8/7.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrPhotoView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var photoDatas: [Photo] = []
    var currentIndex: Int = 0
    var blurBackground: Bool = true
    
    
    private var scrollView: UIScrollView
    private var photoCells: [TumblrPhotoCell] = []
    
    // MARK: - 初始化方法
    init(photos: [Photo], currentIndex: Int) {
        
        self.scrollView = UIScrollView()
        self.currentIndex = currentIndex
        self.photoDatas = photos
        
        super.init(frame: UIScreen.mainScreen().bounds)
        customInit()
    }
    
    // MARK: - Constructors
    required init?(coder aDecoder: NSCoder) {
        
        self.scrollView = UIScrollView()
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        self.scrollView = UIScrollView()
        super.init(frame: frame)
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.fromARGB(0x000000, alpha: 0.7)
        self.frame = UIScreen.mainScreen().bounds
        //TODO background
        
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
            photoCell.left = CGFloat(index) * kScreenWidth
            photoCell.containerView.frame = photoCell.bounds
            photoCells.append(photoCell)
            self.scrollView.addSubview(photoCell)
        }
    }
    
    func singleTapAction(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    func doubleTapAction(gesture: UITapGestureRecognizer) {
        
    }
    
    // MARK: - 显示
    func present(displayContainer: UIView) {
        
        displayContainer.addSubview(self)
        
        let count = self.photoDatas.count
        self.scrollView.contentSize = CGSizeMake(CGFloat(count) * kScreenWidth, kScreenHeight)
        let currentRect = CGRectMake(kScreenWidth * CGFloat(currentIndex), 0, kScreenWidth, kScreenHeight)
        self.scrollView.scrollRectToVisible(currentRect, animated: false)

        self.scrollViewDidScroll(self.scrollView)
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
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    // MARK: - UIGestureRecognizerDelegate

}




















