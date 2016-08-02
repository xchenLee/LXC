//
//  TumblrNameEntry0.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Kingfisher

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
        self.avatarView.top = kTMCellPadding
        self.avatarView.left = kTMCellPadding
        self.avatarView.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        self.blogNameView.backgroundColor = UIColor.whiteColor()
        self.blogNameView.font = kTMCellMainTextFont
        self.blogNameView.textColor = kTMCellMainTextColor
        self.blogNameView.top = kTMCellPadding
        self.blogNameView.left = kTMCellPadding * 2 + kTMCellAvatarSize
        
        
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
        self.avatarView.top = kTMCellPadding
        self.avatarView.left = kTMCellPadding
        self.avatarView.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        self.blogNameView.backgroundColor = UIColor.whiteColor()
        self.blogNameView.font = kTMCellMainTextFont
        self.blogNameView.textColor = kTMCellMainTextColor
        self.blogNameView.top = kTMCellPadding
        self.blogNameView.size = CGSizeMake(0, kTMCellBlogNameFontSize + 2)
        self.blogNameView.left = kTMCellPadding * 2 + kTMCellAvatarSize

        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.addSubview(self.topLine)
        self.addSubview(self.avatarView)
        self.addSubview(self.blogNameView)

    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        //头像
        let tumblrPost = tumblrLayout.post!
        let urlString = tumblrPost.avatarUrl
        let url = NSURL(string: urlString)
        
        self.avatarView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: [KingfisherOptionsInfoItem.Transition(ImageTransition.Fade(0.2))])
        
        //blog
        self.blogNameView.width = tumblrLayout.blogNameWidth
        self.blogNameView.text = tumblrPost.blogName
        
        
    }

    

}
