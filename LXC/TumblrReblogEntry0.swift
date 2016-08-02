//
//  TumblrReblogEntry0.swift
//  LXC
//
//  Created by renren on 16/8/2.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrReblogEntry0: UIView {
    
    var reblogLabel: UILabel
    var reblogTextLabel: UITextView

    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.reblogLabel = UILabel()
        self.reblogLabel.backgroundColor = UIColor.whiteColor()
        self.reblogLabel.font = kTMCellMainTextFont
        self.reblogLabel.textColor = kTMCellMainTextColor
        self.reblogLabel.top = kTMCellPadding
        self.reblogLabel.left = kTMCellPadding
        self.reblogLabel.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.scrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.whiteColor()
        self.reblogTextLabel.font = kTMCellMainTextFont
        self.reblogTextLabel.textColor = kTMCellMainTextColor
        self.reblogTextLabel.top = kTMCellPadding
        self.reblogTextLabel.left = kTMCellPadding
        self.reblogTextLabel.editable = false
        self.reblogTextLabel.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        self.reblogLabel = UILabel()
        self.reblogLabel.backgroundColor = UIColor.whiteColor()
        self.reblogLabel.font = kTMCellMainTextFont
        self.reblogLabel.textColor = kTMCellMainTextColor
        self.reblogLabel.top = kTMCellPadding
        self.reblogLabel.left = kTMCellPadding
        self.reblogLabel.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.scrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.whiteColor()
        self.reblogTextLabel.font = kTMCellMainTextFont
        self.reblogTextLabel.textColor = kTMCellMainTextColor
        self.reblogTextLabel.top = kTMCellPadding
        self.reblogTextLabel.left = kTMCellPadding
        self.reblogTextLabel.editable = false
        self.reblogTextLabel.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)

        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.addSubview(self.reblogLabel)
        self.addSubview(self.reblogTextLabel)
        
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
        if tumblrLayout.reblogHeight == 0 {
            self.reblogTextLabel.attributedText = nil
            self.reblogTextLabel.hidden = true
            return
        }
        self.reblogTextLabel.hidden = false
        NSUnderlineStyleAttributeName
        self.reblogTextLabel.attributedText = tumblrLayout.reblogAttributes
        self.reblogTextLabel.linkTextAttributes = [NSForegroundColorAttributeName : kTMCellReblogTextColor]
        self.reblogTextLabel.frame = CGRectMake(kTMCellPadding, kTMCellPadding, kScreenWidth - 2 * kTMCellPadding, tumblrLayout.reblogHeight)
        //self.reblogLabel.height = tumblrLayout.reblogHeight
        
    }

}
