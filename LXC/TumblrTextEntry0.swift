//
//  TumblrTextEntry0.swift
//  LXC
//
//  Created by renren on 16/8/2.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrTextEntry0: UIView {

    var textView: UITextView
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.textView = UITextView()
        self.textView.scrollEnabled = false
        self.textView.backgroundColor = UIColor.whiteColor()
        self.textView.font = kTMCellReblogFont
        self.textView.textColor = kTMCellReblogTextColor
        self.textView.top = kTMCellPadding
        self.textView.left = kTMCellPadding
        self.textView.editable = false
        self.textView.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        self.textView = UITextView()
        self.textView.scrollEnabled = false
        self.textView.backgroundColor = UIColor.whiteColor()
        self.textView.font = kTMCellReblogFont
        self.textView.textColor = kTMCellReblogTextColor
        self.textView.top = 0
        self.textView.left = kTMCellPadding
        self.textView.editable = false
        self.textView.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, 0)
        
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.addSubview(self.textView)
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
        if tumblrLayout.textHeight == 0 {
            self.textView.attributedText = nil
            self.textView.hidden = true
            return
        }
        self.textView.hidden = false

        self.textView.attributedText = tumblrLayout.textAttributedString
        
        self.textView.frame = CGRectMake(kTMCellPadding, 0, kScreenWidth - 2 * kTMCellPadding, tumblrLayout.textHeight)
        
    }


}
