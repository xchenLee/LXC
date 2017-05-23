//
//  TumblrTagEntry0.swift
//  LXC
//
//  Created by renren on 16/8/8.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit


class TumblrTagEntry0: UIView, TumblrTagPanelProtocol {
    
    var textView: TumblrTagPanel
    var cell: TumblrNormalCell?

    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        textView = TumblrTagPanel()
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        textView = TumblrTagPanel()
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.isExclusiveTouch = true
        
        
        self.textView.backgroundColor = UIColor.white
        self.textView.tapPanelDelegate = self
        self.addSubview(self.textView)
        
        /*self.textView.backgroundColor = UIColor.white
        self.textView.dataDetectorTypes = .link
        self.textView.isUserInteractionEnabled = true
        self.textView.isEditable = false
        self.textView.isScrollEnabled = false
        self.addSubview(self.textView)
        
        self.textView.tapTagAction = { tagName in
        
            guard let safeCell = self.cell ,let delegate = safeCell.delegate else {
                return
            }

            delegate.didClickTag(safeCell, tag: tagName)
        }*/
    }
    
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        
        guard let post = tumblrLayout.post else {
            self.textView.frame = CGRect.zero
            return
        }
        
        self.textView.frame = CGRect(x: kTMCellPadding, y: 0, width: kScreenWidth - 2 * kTMCellPadding, height: tumblrLayout.tagsHeight)
        //self.textView.attributedText = tumblrLayout.tagsAttributedString
        self.textView.fitTags(post.tags)

    }

    // MARK: - TumblrTagPanelProtocol
    func tagTapped(tagName: String) {
        guard let safeCell = self.cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickTag(safeCell, tag: tagName)
    }

}

