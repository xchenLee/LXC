//
//  TumblrNormalCell.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol TumblrNormalCellDelegate {
    
    func didClickCopySourceBtn(_ cell: TumblrNormalCell)
    func didClickLikeBtn(_ cell: TumblrNormalCell)
    func didClickImage(_ cell: TumblrNormalCell, index: Int)
    func didClickTag(_ cell: TumblrNormalCell, tag: String)
    func didClickOuterVideo(_ cell: TumblrNormalCell)
    func didLongPressVideo(_ cell: TumblrNormalCell)
    func didClickAvatar(_ cell: TumblrNormalCell)

}

class TumblrNormalCell: UITableViewCell {
    
    var layout: TumblrNormalLayout?
    
    var nameEntry: TumblrNameEntry0
    var textEntry: TumblrTextEntry0
    var imagesEntry: TumblrImageEntry0
    var videoEntry: TumblrVideoEntry0
    var reblogEntry: TumblrReblogEntry0
    var tagEntry: TumblrTagEntry0
    var toolBarEntry: TumblrToolBarEntry0
    
    var delegate: TumblrNormalCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.nameEntry = TumblrNameEntry0()
        self.textEntry = TumblrTextEntry0()
        self.imagesEntry = TumblrImageEntry0()
        self.videoEntry = TumblrVideoEntry0()
        self.reblogEntry = TumblrReblogEntry0()
        self.tagEntry = TumblrTagEntry0()
        self.toolBarEntry = TumblrToolBarEntry0()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.nameEntry = TumblrNameEntry0()
        self.textEntry = TumblrTextEntry0()
        self.imagesEntry = TumblrImageEntry0()
        self.videoEntry = TumblrVideoEntry0()
        self.reblogEntry = TumblrReblogEntry0()
        self.tagEntry = TumblrTagEntry0()
        self.toolBarEntry = TumblrToolBarEntry0()
        
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    
    func customInit() {
        
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(self.nameEntry)
        self.contentView.addSubview(self.textEntry)
        self.contentView.addSubview(self.imagesEntry)
        self.contentView.addSubview(self.videoEntry)
        self.contentView.addSubview(self.reblogEntry)
        self.contentView.addSubview(self.tagEntry)
        self.contentView.addSubview(self.toolBarEntry)
        
        self.nameEntry.cell = self
        self.textEntry.cell = self
        self.imagesEntry.cell = self
        self.videoEntry.cell = self
        self.reblogEntry.cell = self
        self.tagEntry.cell = self
        self.toolBarEntry.cell = self

    }
    
    func configLayout(_ tumblrLayout: TumblrNormalLayout) {
        self.layout = tumblrLayout
        guard let safeLayout = self.layout else {
            return
        }
        self.contentView.height = safeLayout.height
        self.height = safeLayout.height
        
        //名字区域
        self.nameEntry.top = safeLayout.nameTop
        self.nameEntry.left = 0;
        self.nameEntry.width = kScreenWidth
        self.nameEntry.height = safeLayout.nameHeight
        self.nameEntry.setWithLayout(safeLayout)
        
        //文本区域
        self.textEntry.frame = CGRect(x: 0, y: safeLayout.textTop, width: kScreenWidth, height: safeLayout.textHeight)
        self.textEntry.setWithLayout(safeLayout)
        
        //图片区域
        self.imagesEntry.frame = CGRect(x: 0, y: safeLayout.imagesTop, width: kTMCellImageContentWidth, height: safeLayout.height)
        self.imagesEntry.setWithPhotoData(safeLayout.post?.photos, rects: safeLayout.imagesFrame)
        
        //视频区域
        self.videoEntry.frame = CGRect(x: 0, y: safeLayout.videoTop, width: kScreenWidth, height: safeLayout.videoHeight)
        self.videoEntry.setWithLayout(safeLayout)
        
        //reblog
        self.reblogEntry.frame = CGRect(x: 0, y: safeLayout.reblogTop, width: kScreenWidth, height: safeLayout.reblogHeight)
        self.reblogEntry.setWithLayout(safeLayout)
        
        //tag
        self.tagEntry.frame = CGRect(x: 0, y: safeLayout.tagsTop, width: kScreenWidth, height: safeLayout.tagsHeight)
        self.tagEntry.setWithLayout(safeLayout)
        
        //toolbar
        self.toolBarEntry.frame = CGRect(x: 0, y: safeLayout.toolbarTop, width: kScreenWidth, height: kTMCellToolBarHeight)
        self.toolBarEntry.setWithLayout(safeLayout)
        
    }
    
    func likeChanged() {
        guard let layout = self.layout, let post = layout.post else {
            return
        }
        post.liked = !post.liked
        self.toolBarEntry.likeChanged(post.liked)
    }
    

}

