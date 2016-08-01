//
//  TumblrImagesEntry.swift
//  LXC
//
//  Created by renren on 16/7/30.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import YYKit

class TumblrImagesEntry: ViewTouchable {

    var imageViews : [UIImageView]
    var tumblrCell : TumblrCell?
    
    
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
    
    func customInit() {
        
        for imageView in imageViews {
            self.addSubview(imageView)
        }
        
        self.touchBlock = {(view, state, touches, event) -> Void in
            
            if state != YYGestureRecognizerState.Ended {
                return
            }
            
            let touch = touches?.first
            guard let point = touch?.locationInView(self) else {
                return
            }
            let index = self.imageIndex(point)
            if index == NSNotFound {
                return
            }
            //TODO
//            if self.tumblrCell && self.tumblrCell?.respondsToSelector(Selector()) {
//                <#code#>
//            }
            
        }
        
        self.longPressBlock = {(view, point) -> Void in
            
            guard let safePoint = point else {
                return
            }
            
            let index = self.imageIndex(safePoint)
            
            if index == NSNotFound {
                return
            }
            //TODO
        
        }
        
    }
    
    func imageIndex(point: CGPoint) -> Int {
        
        for index in 0...kTMCellMaxPhotoCount {
            
            let imageView = self.imageViews[index]
            if !imageView.hidden && CGRectContainsPoint(imageView.frame, point){
                return index
            }
        }
        return NSNotFound
    }
    
    func fitWithImages(photos: [Photo]?) {
        
        var count = photos?.count
        
        
    }

}





















