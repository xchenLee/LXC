//
//  TumblrNormalCell.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrNormalCell: UITableViewCell {
    
    var layout: TumblrNormalLayout?
    
    var nameEntry: TumblrNameEntry0
    var textEntry: TumblrTextEntry0
    var imagesEntry: TumblrImageEntry0
    var videoEntry: TumblrVideoEntry0
    var reblogEntry: TumblrReblogEntry0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.nameEntry = TumblrNameEntry0()
        self.textEntry = TumblrTextEntry0()
        self.imagesEntry = TumblrImageEntry0()
        self.videoEntry = TumblrVideoEntry0()
        self.reblogEntry = TumblrReblogEntry0()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.nameEntry = TumblrNameEntry0()
        self.textEntry = TumblrTextEntry0()
        self.imagesEntry = TumblrImageEntry0()
        self.videoEntry = TumblrVideoEntry0()
        self.reblogEntry = TumblrReblogEntry0()
        
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
    }
    
    func configLayout(tumblrLayout: TumblrNormalLayout) {
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
        self.textEntry.frame = CGRectMake(0, safeLayout.textTop, kScreenWidth, safeLayout.textHeight)
        self.textEntry.setWithLayout(safeLayout)
        
        //图片区域
        self.imagesEntry.frame = CGRectMake(0, safeLayout.imagesTop, kTMCellImageContentWidth, safeLayout.height)
        self.imagesEntry.setWithPhotoData(safeLayout.post?.photos, rects: safeLayout.imagesFrame)
        
        //视频区域
        self.videoEntry.frame = CGRectMake(0, safeLayout.videoTop, kScreenWidth, safeLayout.videoHeight)
        self.videoEntry.setWithLayout(safeLayout)
        
        //reblog
        self.reblogEntry.frame = CGRectMake(0, safeLayout.reblogTop, kScreenWidth, safeLayout.reblogHeight)
        self.reblogEntry.setWithLayout(safeLayout)
        
    }
    

}











