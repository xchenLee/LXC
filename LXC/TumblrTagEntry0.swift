//
//  TumblrTagEntry0.swift
//  LXC
//
//  Created by renren on 16/8/8.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrTagEntry0: UIView {
    
    var textView: TumblrTagView
    var cell: TumblrNormalCell?

    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        textView = TumblrTagView()
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        textView = TumblrTagView()
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.textView.dataDetectorTypes = .Link
        self.textView.userInteractionEnabled = true
        self.textView.delaysContentTouches = true
//        self.textView.selectable = false 写上会有问题
        self.textView.editable = false
        self.textView.scrollEnabled = false
        self.textView.multipleTouchEnabled = true
        self.textView.canCancelContentTouches = true
        self.addSubview(self.textView)
        
        self.textView.tapTagAction = { tagName in
        
            guard let safeCell = self.cell ,let delegate = safeCell.delegate else {
                return
            }

            delegate.didClickTag(safeCell, tag: tagName)
        }
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
        guard let _ = tumblrLayout.post else {
            self.textView.frame = CGRectZero
            self.textView.attributedText = nil
            return
        }
        self.textView.frame = CGRectMake(kTMCellPadding, 0, kScreenWidth - 2 * kTMCellPadding, tumblrLayout.tagsHeight)
        self.textView.attributedText = tumblrLayout.tagsAttributedString

    }


}
