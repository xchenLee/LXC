//
//  TumblrNameEntry0.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrNameEntry0: UIView {
    
    var topLine: UIView
    var avatarView: UIImageView
    var blogNameView: UILabel
    
    
    // MARK: - constructors
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.topLine = UIView()
        self.topLine.width = kScreenWidth
        self.topLine.height = ToolBox.obtainFloatPixel(1)
        self.topLine.backgroundColor = UIColor.blackColor()
        
        self.avatarView = UIImageView()
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.cornerRadius = kTMCellCornerRadius
        self.avatarView.layer.borderWidth = ToolBox.obtainFloatPixel(1)
        self.avatarView.layer.borderColor = UIColor.blackColor().CGColor
        self.avatarView.left = kTMCellPadding
        self.avatarView.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        
        self.topLine = UIView()
        self.topLine.width = kScreenWidth
        self.topLine.height = ToolBox.obtainFloatPixel(1)
        self.topLine.backgroundColor = UIColor.blackColor()
        
        self.avatarView = UIImageView()
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.cornerRadius = kTMCellCornerRadius
        self.avatarView.layer.borderWidth = ToolBox.obtainFloatPixel(1)
        self.avatarView.layer.borderColor = UIColor.blackColor().CGColor
        self.avatarView.left = kTMCellPadding
        self.avatarView.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.addSubview(self.topLine)
        self.addSubview(self.avatarView)
        

    }

    

}
