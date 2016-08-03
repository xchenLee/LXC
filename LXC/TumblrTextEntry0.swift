//
//  TumblrTextEntry0.swift
//  LXC
//
//  Created by renren on 16/8/2.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrTextEntry0: UIView {

    var titleView: UILabel
    var textView: UITextView
    var cell: TumblrNormalCell?

    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.titleView = UILabel()
        self.titleView.numberOfLines = 0
        self.titleView.backgroundColor = UIColor.whiteColor()
        self.titleView.font = kTMCellTitleFont
        self.titleView.textColor = kTMCellTitleFontColor
        
        
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
        
        self.titleView = UILabel()
        self.titleView.numberOfLines = 0
        self.titleView.backgroundColor = UIColor.whiteColor()
        self.titleView.font = kTMCellTitleFont
        self.titleView.textColor = kTMCellTitleFontColor
        
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
        
        self.addSubview(self.titleView)
        self.addSubview(self.textView)
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
        if tumblrLayout.titleHeight == 0 {
            
            self.titleView.text = ""
            self.titleView.hidden = true
            self.titleView.frame = CGRectZero
        } else {
            
            self.titleView.hidden = false
            self.titleView.text = tumblrLayout.tittleText
            self.titleView.frame = CGRectMake(kTMCellPadding, 0, kTMCellTextContentWidth, tumblrLayout.titleHeight)
        }
        
        
        if tumblrLayout.textHeight == 0 {
            
            self.textView.attributedText = nil
            self.textView.hidden = true
            self.textView.frame = CGRectZero
        } else {
            
            self.textView.hidden = false
            self.textView.attributedText = tumblrLayout.textAttributedString
            self.textView.frame = CGRectMake(kTMCellPadding, tumblrLayout.titleHeight, kTMCellTextContentWidth, tumblrLayout.textHeight)
        }
        
    }


}
