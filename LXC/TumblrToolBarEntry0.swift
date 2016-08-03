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
        copySourceBtn.size = CGSizeMake(kTMCellToolBarHeight, kTMCellToolBarHeight)
        copySourceBtn.top = 0
        copySourceBtn.setImage(UIImage(named: "icon_clipboard"), forState: .Normal)
        copySourceBtn.left = kScreenWidth - kTMCellPadding - kTMCellToolBarHeight
        copySourceBtn.backgroundColor = UIColor.whiteColor()
        
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
        
        self.copySourceBtn.addTarget(self, action: #selector(clickCopySourceBtn), forControlEvents: .TouchUpInside)
        
    }
    
    func clickCopySourceBtn(button: UIButton) {
        
        guard let safeCell = cell ,let delegate = safeCell.delegate else {
            return
        }
        delegate.didClickCopySourceBtn(safeCell)
        
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
    }

}
