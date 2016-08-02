//
//  TumblrReblogEntry0.swift
//  LXC
//
//  Created by renren on 16/8/2.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrReblogEntry0: UIView {
    
    var reblogTextLabel: UITextView

    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.scrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.whiteColor()
        self.reblogTextLabel.font = kTMCellReblogFont
        self.reblogTextLabel.textColor = kTMCellReblogTextColor
        self.reblogTextLabel.top = kTMCellPadding
        self.reblogTextLabel.left = kTMCellPadding
        self.reblogTextLabel.editable = false
        self.reblogTextLabel.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.scrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.whiteColor()
        self.reblogTextLabel.font = kTMCellReblogFont
        self.reblogTextLabel.textColor = kTMCellReblogTextColor
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
        self.reblogTextLabel.frame = CGRectMake(kTMCellPadding, 0, kScreenWidth - 2 * kTMCellPadding, tumblrLayout.reblogHeight)
        
    }

}
