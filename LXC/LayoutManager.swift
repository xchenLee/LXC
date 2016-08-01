//
//  LayoutManager.swift
//  LXC
//
//  Created by renren on 16/7/30.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kTMCellImageTagPrefix = 2000

let kTMCellMaxPhotoCount = 10


/// Padding
let kTMCellPadding : CGFloat = 12
let kTMCellImagePadding : CGFloat = 4

/// 图片内容总宽度
let kTMCellImageContentWidth = kScreenWidth
/// 文本总宽度
let kTMCellTextContentWidth = kScreenWidth - 2 * kTMCellPadding


/// 大小
let kTMCellAvatarSize : CGFloat = 48
let kTMCellCornerRadius : CGFloat = 4

let kTMCellBlogNameFontSize : CGFloat = 14
let kTMCellMainTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)


let kTMCellAvatarAreaHeight = kTMCellAvatarSize + kTMCellPadding * 2

/// 图片足最大高度，不超过一屏可见高度
let kTMCellPhotoMaxHeight = kScreenHeight - 50 - 64
let kTMCellPhotoMaxWidth = kScreenWidth

let kTMCellPhotoMaxSize = CGSizeMake(kTMCellPhotoMaxWidth, kTMCellPhotoMaxHeight)


class LayoutManager: NSObject {
    
    
    
    
    class func computeImagesHeight(photos: [Photo]?) -> CGFloat {
        
        guard let photoData = photos else {
            return 0
        }
        
        if photoData.count == 1 {
            
            let photoSize = photoData[0].originalSize
            
            guard let realSize = photoSize else {
                return 0
            }
            let originalSize = CGSizeMake(CGFloat(realSize.width), CGFloat(realSize.height))
            let scaleSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
            return scaleSize.height
        }
        
        if photoData.count == 2 {
            
            let photoSize0 = photoData[0].originalSize
            let photoSize1 = photoData[1].originalSize

            guard let realSize0 = photoSize0, let realSize1 = photoSize1 else {
                return 0
            }
            //如果第一张宽度大于高度就竖直排列
            let vertical = realSize0.width >= realSize0.height
            if vertical {
                
                let originalSize0 = CGSizeMake(CGFloat(realSize0.width), CGFloat(realSize0.height))
                let scaleSize0 = ToolBox.getScaleSize(originalSize0, max: kTMCellPhotoMaxSize)
                
                let originalSize1 = CGSizeMake(CGFloat(realSize1.width), CGFloat(realSize1.height))
                let scaleSize1 = ToolBox.getScaleSize(originalSize1, max: kTMCellPhotoMaxSize)
                
                return scaleSize0.height + scaleSize1.height
            } else {
                
                let minOriginalHeight = min(realSize0.height, realSize1.height)
                var pairedWidth = realSize0.width
                if minOriginalHeight == realSize1.height {
                    pairedWidth = realSize1.width
                }
                
                let originalSize = CGSizeMake(CGFloat(pairedWidth), CGFloat(minOriginalHeight))
                let maxSize = CGSizeMake(kScreenWidth / 2, kTMCellPhotoMaxHeight / 2)
                let scaleSize = ToolBox.getScaleSize(originalSize, max: maxSize)
                
                return scaleSize.height
            } 
        }
        
        
        return 0
    }

}















