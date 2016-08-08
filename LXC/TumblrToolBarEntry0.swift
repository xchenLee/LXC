//
//  TumblrToolBarEntry0.swift
//  LXC
//
//  Created by renren on 16/8/4.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrToolBarEntry0: UIView {

    var toolbarSeperatorLine: UIView
    var copySourceBtn: UIButton
    var likeBtn: UIButton
    var cell: TumblrNormalCell?
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        toolbarSeperatorLine = UIView()
        toolbarSeperatorLine.backgroundColor = kTMCellLineColorAlpha
        toolbarSeperatorLine.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, ToolBox.obtainFloatPixel(1))
        toolbarSeperatorLine.left = kTMCellPadding
        toolbarSeperatorLine.top = 0
        
        copySourceBtn = UIButton(type: .Custom)
        copySourceBtn.size = CGSizeMake(kTMCellToolBarHeight, kTMCellToolBarHeight)
        copySourceBtn.top = 0
        copySourceBtn.setImage(UIImage(named: "icon_clipboard"), forState: .Normal)
        copySourceBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight
        copySourceBtn.backgroundColor = UIColor.whiteColor()
        
        likeBtn = UIButton(type: .Custom)
        likeBtn.size = CGSizeMake(kTMCellToolBarHeight, kTMCellToolBarHeight)
        likeBtn.top = 0
        likeBtn.setImage(UIImage(named: "icon_clipboard"), forState: .Normal)
        likeBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight * 2
        likeBtn.backgroundColor = UIColor.whiteColor()
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        toolbarSeperatorLine = UIView()
        toolbarSeperatorLine.backgroundColor = kTMCellLineColorAlpha
        toolbarSeperatorLine.size = CGSizeMake(kScreenWidth - 2 * kTMCellPadding, ToolBox.obtainFloatPixel(1))
        toolbarSeperatorLine.left = kTMCellPadding
        toolbarSeperatorLine.top = 0
        
        copySourceBtn = UIButton(type: .Custom)
        copySourceBtn.size = CGSizeMake(kTMCellToolBarHeight, kTMCellToolBarHeight-2)
        copySourceBtn.top = 1
        copySourceBtn.setImage(UIImage(named: "icon_clipboard"), forState: .Normal)
        copySourceBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight
        copySourceBtn.backgroundColor = UIColor.whiteColor()
        
        likeBtn = UIButton(type: .Custom)
        likeBtn.size = CGSizeMake(kTMCellToolBarHeight, kTMCellToolBarHeight - 2)
        likeBtn.top = 1
        likeBtn.setImage(UIImage(named: "icon_like"), forState: .Normal)
        likeBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight * 2
        likeBtn.backgroundColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.copySourceBtn)
        self.addSubview(self.toolbarSeperatorLine)
        self.addSubview(self.likeBtn)
        
        self.copySourceBtn.addTarget(self, action: #selector(clickCopySourceBtn), forControlEvents: .TouchUpInside)
        
        self.likeBtn.addTarget(self, action: #selector(clickLikeBtn), forControlEvents: .TouchUpInside)
        
    }
    
    func clickCopySourceBtn(button: UIButton) {
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickCopySourceBtn(safeCell)
        
    }
    
    func clickLikeBtn(button: UIButton) {
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickLikeBtn(safeCell)
        
    }
    
    func likeChanged(state: Bool) {
        let name = state ? "icon_liked" : "icon_like"
        likeBtn.setImage(UIImage(named: name), forState: .Normal)
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        guard let post = tumblrLayout.post else {
            return
        }
        let name = post.liked ? "icon_liked" : "icon_like"
        likeBtn.setImage(UIImage(named: name), forState: .Normal)
    }

}
