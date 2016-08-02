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
    var imagesEntry: TumblrImageEntry0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.nameEntry = TumblrNameEntry0()
        self.imagesEntry = TumblrImageEntry0()
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.nameEntry = TumblrNameEntry0()
        self.imagesEntry = TumblrImageEntry0()
        
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    
    func customInit() {
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(self.nameEntry)
        self.contentView.addSubview(self.imagesEntry)
    }
    
    func configLayout(tumblrLayout: TumblrNormalLayout) {
        self.layout = tumblrLayout
        guard let safeLayout = self.layout else {
            return
        }
        self.contentView.height = safeLayout.height
        self.height = safeLayout.height
        
        self.nameEntry.top = safeLayout.nameTop
        self.nameEntry.frame = CGRectMake(0, 0, kScreenWidth, safeLayout.nameHeight)
//        self.nameEntry.left = 0;
//        self.nameEntry.width = kScreenWidth
//        self.nameEntry.height = safeLayout.nameHeight
        
        self.imagesEntry.top = safeLayout.imagesTop
        self.imagesEntry.left = 0
        self.imagesEntry.width = kTMCellImageContentWidth
        self.imagesEntry.height = safeLayout.height
        self.imagesEntry.setWithPhotoData(safeLayout.post?.photos, rects: safeLayout.imagesFrame)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}











