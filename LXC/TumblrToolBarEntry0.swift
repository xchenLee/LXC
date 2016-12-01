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
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        toolbarSeperatorLine = UIView()
        toolbarSeperatorLine.backgroundColor = kTMCellLineColorAlpha
        toolbarSeperatorLine.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: ToolBox.obtainFloatPixel(1))
        toolbarSeperatorLine.left = kTMCellPadding
        toolbarSeperatorLine.top = 0
        
        copySourceBtn = UIButton(type: .custom)
        copySourceBtn.size = CGSize(width: kTMCellToolBarHeight, height: kTMCellToolBarHeight)
        copySourceBtn.top = 0
        copySourceBtn.setImage(UIImage(named: "icon_clipboard"), for: UIControlState())
        copySourceBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight
        copySourceBtn.backgroundColor = UIColor.white
        
        likeBtn = UIButton(type: .custom)
        likeBtn.size = CGSize(width: kTMCellToolBarHeight, height: kTMCellToolBarHeight)
        likeBtn.top = 0
        likeBtn.setImage(UIImage(named: "icon_clipboard"), for: UIControlState())
        likeBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight * 2
        likeBtn.backgroundColor = UIColor.white
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        toolbarSeperatorLine = UIView()
        toolbarSeperatorLine.backgroundColor = kTMCellLineColorAlpha
        toolbarSeperatorLine.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: ToolBox.obtainFloatPixel(1))
        toolbarSeperatorLine.left = kTMCellPadding
        toolbarSeperatorLine.top = 0
        
        copySourceBtn = UIButton(type: .custom)
        copySourceBtn.backgroundColor = UIColor.white
        copySourceBtn.size = CGSize(width: kTMCellToolBarHeight, height: kTMCellToolBarHeight-2)
        copySourceBtn.top = 1
        copySourceBtn.setImage(UIImage(named: "icon_clipboard"), for: UIControlState())
        copySourceBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight
        copySourceBtn.backgroundColor = UIColor.white
        
        likeBtn = UIButton(type: .custom)
        likeBtn.backgroundColor = UIColor.white
        likeBtn.size = CGSize(width: kTMCellToolBarHeight, height: kTMCellToolBarHeight - 2)
        likeBtn.top = 1
        likeBtn.setImage(UIImage(named: "icon_like"), for: UIControlState())
        likeBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight * 2
        likeBtn.backgroundColor = UIColor.white
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.backgroundColor = UIColor.white
        self.addSubview(self.copySourceBtn)
        self.addSubview(self.toolbarSeperatorLine)
        self.addSubview(self.likeBtn)
        
        self.copySourceBtn.addTarget(self, action: #selector(clickCopySourceBtn), for: .touchUpInside)
        
        self.likeBtn.addTarget(self, action: #selector(clickLikeBtn), for: .touchUpInside)
        
    }
    
    func clickCopySourceBtn(_ button: UIButton) {
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickCopySourceBtn(safeCell)
        
    }
    
    func clickLikeBtn(_ button: UIButton) {
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickLikeBtn(safeCell)
        
    }
    
    func likeChanged(_ state: Bool) {
        let name = state ? "icon_liked" : "icon_like"
        likeBtn.setImage(UIImage(named: name), for: UIControlState())
    }
    
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        guard let post = tumblrLayout.post else {
            return
        }
        let name = post.liked ? "icon_liked" : "icon_like"
        likeBtn.setImage(UIImage(named: name), for: UIControlState())
    }

}
