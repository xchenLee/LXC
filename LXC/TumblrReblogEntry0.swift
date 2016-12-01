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
    var cell: TumblrNormalCell?


    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.isScrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.white
        self.reblogTextLabel.font = kTMCellReblogFont
        self.reblogTextLabel.textColor = kTMCellReblogTextColor
        self.reblogTextLabel.top = kTMCellPadding
        self.reblogTextLabel.left = kTMCellPadding
        self.reblogTextLabel.isEditable = false
        self.reblogTextLabel.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: 0)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        self.reblogTextLabel = UITextView()
        self.reblogTextLabel.isScrollEnabled = false
        self.reblogTextLabel.backgroundColor = UIColor.white
        self.reblogTextLabel.font = kTMCellReblogFont
        self.reblogTextLabel.textColor = kTMCellReblogTextColor
        self.reblogTextLabel.top = kTMCellPadding
        self.reblogTextLabel.left = kTMCellPadding
        self.reblogTextLabel.isEditable = false
        self.reblogTextLabel.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: 0)

        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.addSubview(self.reblogTextLabel)
        
    }
    
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        
        if tumblrLayout.reblogHeight == 0 {
            self.reblogTextLabel.attributedText = nil
            self.reblogTextLabel.isHidden = true
            return
        }
        self.reblogTextLabel.isHidden = false
        NSUnderlineStyleAttributeName
        self.reblogTextLabel.attributedText = tumblrLayout.reblogAttributes
        self.reblogTextLabel.linkTextAttributes = [NSForegroundColorAttributeName : kTMCellReblogTextColor]
        self.reblogTextLabel.frame = CGRect(x: kTMCellPadding, y: 0, width: kScreenWidth - 2 * kTMCellPadding, height: tumblrLayout.reblogHeight)
        
    }

}
