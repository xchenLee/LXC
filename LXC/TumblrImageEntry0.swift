//
//  TumblrImageEntry0.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrImageEntry0: UIView {

    var imageViews : [UIImageView]
    
    
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
        
    }
    

}
