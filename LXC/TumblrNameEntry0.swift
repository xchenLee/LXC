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
    var cell: TumblrNormalCell?

    
    
    // MARK: - constructors
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.topLine = UIView()
        self.topLine.width = kScreenWidth
        self.topLine.height = ToolBox.obtainFloatPixel(1)
        self.topLine.backgroundColor = kTMCellLineColor
        
        self.avatarView = UIImageView()
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.cornerRadius = kTMCellCornerRadius
        self.avatarView.layer.contentsScale = UIScreen.main.scale
        self.avatarView.layer.shouldRasterize = true
        self.avatarView.layer.borderWidth = ToolBox.obtainFloatPixel(1)
        self.avatarView.layer.borderColor = UIColor.black.cgColor
        self.avatarView.top = kTMCellPadding
        self.avatarView.left = kTMCellPadding
        self.avatarView.size = CGSize(width: kTMCellAvatarSize, height: kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        self.blogNameView.backgroundColor = UIColor.white
        self.blogNameView.font = kTMCellBlogNameFont
        self.blogNameView.textColor = kTMCellBlogNameTextColor
        self.blogNameView.top = kTMCellPadding
        self.blogNameView.left = kTMCellPadding * 2 + kTMCellAvatarSize
        
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        
        self.topLine = UIView()
        self.topLine.width = kScreenWidth
        self.topLine.height = ToolBox.obtainFloatPixel(1)
        self.topLine.backgroundColor = kTMCellLineColor
        
        self.avatarView = UIImageView()
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.shouldRasterize = true
        self.avatarView.layer.rasterizationScale = UIScreen.main.scale
        self.avatarView.layer.cornerRadius = kTMCellCornerRadius
        self.avatarView.layer.borderWidth = ToolBox.obtainFloatPixel(1)
        self.avatarView.layer.borderColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0).cgColor
        self.avatarView.top = kTMCellPadding
        self.avatarView.left = kTMCellPadding
        self.avatarView.backgroundColor = UIColor.white
        self.avatarView.size = CGSize(width: kTMCellAvatarSize, height: kTMCellAvatarSize)
        
        self.blogNameView = UILabel()
        self.blogNameView.backgroundColor = UIColor.white
        self.blogNameView.font = kTMCellBlogNameFont
        self.blogNameView.textColor = kTMCellBlogNameTextColor
        self.blogNameView.top = kTMCellPadding
        self.blogNameView.size = CGSize(width: 0, height: kTMCellBlogNameFontSize + 2)
        self.blogNameView.left = kTMCellPadding * 2 + kTMCellAvatarSize

        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.isExclusiveTouch = true
        self.addSubview(self.topLine)
        self.addSubview(self.avatarView)
        self.addSubview(self.blogNameView)

    }
    
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        //头像
        let tumblrPost = tumblrLayout.post!
        let urlString = tumblrPost.avatarUrl
        let url = URL(string: urlString)
        
        let defaultAvatar = UIImage(named: "default_avatar")
        
        self.avatarView.kf.setImage(with: url, placeholder: defaultAvatar, options: [.transition(.fade(0.6))], progressBlock: nil, completionHandler: nil)
        
        //blog
        self.blogNameView.width = tumblrLayout.blogNameWidth
        self.blogNameView.text = tumblrPost.blogName
        
        
    }

    

}
