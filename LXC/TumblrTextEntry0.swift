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
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.titleView = UILabel()
        self.titleView.numberOfLines = 0
        self.titleView.backgroundColor = UIColor.white
        self.titleView.font = kTMCellTitleFont
        self.titleView.textColor = kTMCellTitleFontColor
        
        
        self.textView = UITextView()
        self.textView.isScrollEnabled = false
        self.textView.backgroundColor = UIColor.white
        self.textView.font = kTMCellReblogFont
        self.textView.textColor = kTMCellReblogTextColor
        self.textView.top = kTMCellPadding
        self.textView.left = kTMCellPadding
        self.textView.isEditable = false
        self.textView.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: 0)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        self.titleView = UILabel()
        self.titleView.numberOfLines = 0
        self.titleView.backgroundColor = UIColor.white
        self.titleView.font = kTMCellTitleFont
        self.titleView.textColor = kTMCellTitleFontColor
        
        self.textView = UITextView()
        self.textView.isScrollEnabled = false
        self.textView.backgroundColor = UIColor.white
        self.textView.font = kTMCellReblogFont
        self.textView.textColor = kTMCellReblogTextColor
        self.textView.top = 0
        self.textView.left = kTMCellPadding
        self.textView.isEditable = false
        self.textView.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: 0)
        
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.titleView)
        self.addSubview(self.textView)
    }
    
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        
        if tumblrLayout.titleHeight == 0 {
            
            self.titleView.text = ""
            self.titleView.isHidden = true
            self.titleView.frame = CGRect.zero
        } else {
            
            self.titleView.isHidden = false
            self.titleView.text = tumblrLayout.tittleText
            self.titleView.frame = CGRect(x: kTMCellPadding, y: 0, width: kTMCellTextContentWidth, height: tumblrLayout.titleHeight)
        }
        
        
        if tumblrLayout.textHeight == 0 {
            
            self.textView.attributedText = nil
            self.textView.isHidden = true
            self.textView.frame = CGRect.zero
        } else {
            
            self.textView.isHidden = false
            self.textView.attributedText = tumblrLayout.textAttributedString
            self.textView.frame = CGRect(x: kTMCellPadding, y: tumblrLayout.titleHeight, width: kTMCellTextContentWidth, height: tumblrLayout.textHeight)
        }
        
    }


}
