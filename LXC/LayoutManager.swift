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


/// 头像大小
let kTMCellAvatarSize : CGFloat = 48
let kTMCellCornerRadius : CGFloat = 4

/// 文字
let kTMCellTitleFontSize : CGFloat = 20
let kTMCellTitleFontColor = UIColor.fromARGB(0x646464, alpha: 1.0)
let kTMCellTitleFont = UIFont.systemFontOfSize(kTMCellTitleFontSize, weight: UIFontWeightRegular)

let kTMCellTextFontSize: CGFloat = 14
let kTMCellTextFontColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellTextFont = UIFont.systemFontOfSize(kTMCellTextFontSize, weight: UIFontWeightLight)



let kTMCellBlogNameFontSize : CGFloat = 14
let kTMCellBlogNameTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellBlogNameFont = UIFont.systemFontOfSize(kTMCellBlogNameFontSize, weight: UIFontWeightLight)

let kTMCellReblogFontSize : CGFloat = 14
let kTMCellReblogTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellReblogFont = UIFont.systemFontOfSize(kTMCellReblogFontSize, weight: UIFontWeightLight)



let kTMCellAvatarAreaHeight = kTMCellAvatarSize + kTMCellPadding * 2

/// 图片足最大高度，不超过一屏可见高度
let kTMCellPhotoMaxHeight = kScreenHeight - 50 - 64
let kTMCellPhotoMaxWidth = kScreenWidth

let kTMCellPhotoMaxSize = CGSizeMake(kTMCellPhotoMaxWidth, kTMCellPhotoMaxHeight)


class LayoutManager: NSObject {
    
    
    /**
     获取Text的 NSAttributedString
     
     - parameter text: original text
     
     - returns: text的 NSAttributedString
     */
    class func getTextEntryTextAttributedString(text: String) -> NSAttributedString {
        
        //获取转化HTML过后的AS
        let attributedString = text.convertToAttributedString(kTMCellTextFont, textColor: kTMCellTextFontColor)
        let mutableAS = NSMutableAttributedString(attributedString: attributedString)
        
        //开始添加自定义属性，段落，
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.minimumLineHeight = kTMCellTextFontSize * 1.2
        
        let range = NSMakeRange(0, attributedString.length)
        mutableAS.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        mutableAS.addAttribute(NSFontAttributeName, value: kTMCellTextFont, range: range)
        return mutableAS
    }
    
    
    /**
     获取Reblog的 NSAttributedString
     
     - parameter text: original text
     
     - returns: reblog的 NSAttributedString
     */
    class func getReblogEntryTextAttributedString(text: String) -> NSAttributedString {
        
        //获取转化HTML过后的AS
        let attributedString = text.convertToAttributedString(kTMCellReblogFont, textColor: kTMCellReblogTextColor)
        let mutableAS = NSMutableAttributedString(attributedString: attributedString)
        
        //开始添加自定义属性
        
        let range = NSMakeRange(0, attributedString.length)
        mutableAS.addAttribute(NSFontAttributeName, value: kTMCellReblogFont, range: range)
        return mutableAS
    }
    
    
    /**
     计算名字长度
     
     - parameter blogName: blog name
     
     - returns: 文本全部宽度
     */
    class func computeBlogNameWidth(blogName: String) -> CGFloat {
        
        var width = blogName.widthWithConstrainedHeight(kTMCellBlogNameFontSize + 2, font: kTMCellBlogNameFont)
        //预留120
        let maxWidth = kScreenWidth - kTMCellAvatarSize - 2 * kTMCellPadding - 120
        if width > maxWidth {
            width = maxWidth
        }
        return width
    }
    
    /**
     计算reblog信息的高度
     
     - parameter blogName:
     
     - returns: reblog的全高
     */
    class func computeRelogHeight(blogName: NSAttributedString) -> CGFloat {
        
        let height = blogName.heightWithConstrainedWidth(kScreenWidth - 2 * kTMCellPadding)

        return height
    }
    
    
    /**
     计算图片大小，并返回布局信息
     
     - parameter photos: 图片数据
     
     - returns: 元组包含（整个图片控件高度,[imageView的布局]）
     */
    class func computeImagesHeight(photos: [Photo]?) ->  (CGFloat,[CGRect]) {
        
        guard let photoData = photos else {
            return (0, [])
        }
        
        //TODO just for test

        var photoCount = photoData.count
        if photoCount > 2 {
            photoCount = 2
        }
        
        
        if photoCount == 1 {
            
            let photoSize = photoData[0].originalSize
            
            guard let realSize = photoSize else {
                return (0,[CGRectZero])
            }
            if realSize.width == 0 || realSize.height == 0 {
                let width = kScreenWidth
                let height = kScreenWidth * 9 / 16
                return(height, [CGRectMake(0, 0, width, height)])
            }
            
            let originalSize = CGSizeMake(CGFloat(realSize.width), CGFloat(realSize.height))
            let scaleSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
            
            let rect = CGRectMake(0, 0, kScreenWidth, scaleSize.height)
            return (scaleSize.height,[rect])
        }
        
        if photoCount == 2 {
            
            let photoSize0 = photoData[0].originalSize
            let photoSize1 = photoData[1].originalSize

            guard let realSize0 = photoSize0, let realSize1 = photoSize1 else {
                return (0, [CGRectZero, CGRectZero])
            }
            //如果第一张宽度大于高度就竖直排列
            let vertical = realSize0.width > realSize0.height
            

            
            if vertical {
                
                let originalSize0 = CGSizeMake(CGFloat(realSize0.width), CGFloat(realSize0.height))
                
                var scaleSize0 = ToolBox.getScaleSize(originalSize0, max: kTMCellPhotoMaxSize)
                
                if originalSize0.width == 0 || originalSize0.height == 0 {
                    scaleSize0 = CGSizeMake(kScreenWidth, kScreenWidth * 9 / 16)
                }
                
                
                let originalSize1 = CGSizeMake(CGFloat(realSize1.width), CGFloat(realSize1.height))
                var scaleSize1 = ToolBox.getScaleSize(originalSize1, max: kTMCellPhotoMaxSize)
                
                if originalSize1.width == 0 || originalSize1.height == 0 {
                    scaleSize1 = CGSizeMake(kScreenWidth, kScreenWidth * 9 / 16)
                }
                
                let height = scaleSize0.height + scaleSize1.height
                
                let rect0 = CGRectMake(0, 0, kScreenWidth, scaleSize0.height)
                
                let rect1 = CGRectMake(0, scaleSize0.height, kScreenWidth, scaleSize1.height)
                
                return (height,[rect0, rect1])
            } else {
                
                let minOriginalHeight = min(realSize0.height, realSize1.height)
                var pairedWidth = realSize0.width
                if minOriginalHeight == realSize1.height {
                    pairedWidth = realSize1.width
                }
                
                let originalSize = CGSizeMake(CGFloat(pairedWidth), CGFloat(minOriginalHeight))
                let maxSize = CGSizeMake(kScreenWidth / 2, kTMCellPhotoMaxHeight / 2)
                let scaleSize = ToolBox.getScaleSize(originalSize, max: maxSize)
                
                let rect0 = CGRectMake(0, 0, kScreenWidth / 2, scaleSize.height)
                
                let rect1 = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, scaleSize.height)
                return (scaleSize.height,[rect0, rect1])
            }
        }

        return (0, [CGRectZero])
    }

}

