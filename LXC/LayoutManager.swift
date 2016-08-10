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

// indicator 大小
let kTMCellVideoIndicatorSize : CGFloat = 40
let kTMCellVideoFlagSize : CGFloat = 24

/// 文字
let kTMCellTitleFontSize : CGFloat = 20
let kTMCellTitleFontColor = UIColor.fromARGB(0x646464, alpha: 1.0)
let kTMCellTitleFont = UIFont.systemFontOfSize(kTMCellTitleFontSize, weight: UIFontWeightRegular)

let kTMCellTextFontSize: CGFloat = 14
let kTMCellTextFontColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellTextFont = UIFont.systemFontOfSize(kTMCellTextFontSize, weight: UIFontWeightLight)


let kTMCellLineColor = UIColor.fromARGB(0xDCDCDC, alpha: 1.0)
let kTMCellLineColorAlpha = UIColor.fromARGB(0xDCDCDC, alpha: 0.5)

let kTMCellBlogNameFontSize : CGFloat = 14
let kTMCellBlogNameTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellBlogNameFont = UIFont.systemFontOfSize(kTMCellBlogNameFontSize, weight: UIFontWeightLight)

let kTMCellReblogFontSize : CGFloat = 14
let kTMCellReblogTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellReblogFont = UIFont.systemFontOfSize(kTMCellReblogFontSize, weight: UIFontWeightLight)

let kTMCellTagFontSize : CGFloat = 14
let kTMCellTagTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellTagFont = UIFont.systemFontOfSize(kTMCellTagFontSize, weight: UIFontWeightLight)



let kTMCellAvatarAreaHeight = kTMCellAvatarSize + kTMCellPadding * 2
let kTMCellToolBarHeight : CGFloat = 40

/// 图片足最大高度，不超过一屏可见高度
let kTMCellPhotoMaxHeight = kScreenHeight - 68
let kTMCellPhotoMaxWidth = kScreenWidth

let kTMCellPhotoMaxSize = CGSizeMake(kTMCellPhotoMaxWidth, kTMCellPhotoMaxHeight)


let kDebugMaxAllowedPhotoCount = 4

class LayoutManager: NSObject {
    
    
    class func getTagsAttributedString(text: String) -> NSAttributedString {
        
        
        let attributedString = text.convertToAttributedString(kTMCellTextFont, textColor: kTMCellTextFontColor)
                
        let textRange = NSMakeRange(0, text.characters.count)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: kTMCellTagTextColor, range: textRange)
        attributedString.addAttribute(NSFontAttributeName, value: kTMCellTagFont, range: textRange)
        
        
        let expression = try! NSRegularExpression(pattern: kCustomDetectionTagPattern, options: [])
        
        expression.enumerateMatchesInString(text, options: [], range: textRange) { (result, flags, stop) in
            
            guard let matchingResult = result else {
               return
            }
            
            let startIndex = text.startIndex.advancedBy(matchingResult.range.location)
            let endIndex = startIndex.advancedBy(matchingResult.range.length)
            let range = startIndex..<endIndex
            
            let matchedString = text.substringWithRange(range)
            
            let attributes = [
                NSLinkAttributeName : matchedString,
                kCustomDetectionTypeName : kCustomDetectionTypeTag
            ]
            

            attributedString.addAttributes(attributes, range: matchingResult.range)
        }

        return attributedString
    }
    
    
    /**
     获取Text的 NSAttributedString
     
     - parameter text: original text
     
     - returns: text的 NSAttributedString
     */
    class func getTextEntryTextAttributedString(text: String) -> NSAttributedString {
        
        //获取转化HTML过后的AS
        let mutableAS = text.convertToAttributedString(kTMCellTextFont, textColor: kTMCellTextFontColor)
        
        //开始添加自定义属性，段落，
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.minimumLineHeight = kTMCellTextFontSize * 1.2
        
        let range = NSMakeRange(0, mutableAS.length)
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
        let mutableAS = text.convertToAttributedString(kTMCellReblogFont, textColor: kTMCellReblogTextColor)
        
        //开始添加自定义属性
        
        let range = NSMakeRange(0, mutableAS.length)
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
    
    class func computeTagsHeight(tagsText: NSAttributedString) -> CGFloat {
        
        let height = tagsText.heightWithConstrainedWidth(kScreenWidth - 2 * kTMCellPadding)
        
        return height + kTMCellPadding
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
        if photoCount > kDebugMaxAllowedPhotoCount {
            photoCount = kDebugMaxAllowedPhotoCount
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
                return (0, Array<CGRect>(count: photoCount, repeatedValue: CGRectZero))
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
        
        
        if photoCount == 3 {
            
            var resultRects = Array<CGRect>(count: photoCount, repeatedValue: CGRectZero)
            
            guard let _ = photoData[0].originalSize else {
                return (0, resultRects)
            }
            
            var rectTop: CGFloat = 0
            for index in 0..<photoCount {
                
                guard let photoSize = photoData[index].originalSize else {
                    continue
                }
                let originalSize = CGSizeMake(CGFloat(photoSize.width), CGFloat(photoSize.height))
                var scaledSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                if originalSize.width == 0 || originalSize.height == 0 {
                    scaledSize = CGSizeMake(kScreenWidth, kScreenWidth * 9 / 16)
                }
                let rect = CGRectMake(0, rectTop, kScreenWidth, scaledSize.height)
                rectTop += scaledSize.height
                resultRects[index] = rect
            }
            return(rectTop, resultRects)
        }
        
        if photoCount == 4 {
            
            var resultRects = Array<CGRect>(count: photoCount, repeatedValue: CGRectZero)
            
            guard let photoSize0 = photoData[0].originalSize else {
                return (0, resultRects)
            }
            
            var rectTop: CGFloat = 0

            if CGFloat(photoSize0.width) < kScreenWidth {
                //第一张宽度小于屏幕宽度,就两张并列放置
                
                let maxWidth = kScreenWidth / 2
                
                let originalSize0 = CGSizeMake(CGFloat(photoSize0.width), CGFloat(photoSize0.height))
                var scaleSize0 = ToolBox.getScaleSize(originalSize0, max: CGSizeMake(maxWidth, kTMCellPhotoMaxHeight / 2))
                if originalSize0.width == 0 || originalSize0.height == 0 {
                    scaleSize0 = CGSizeMake(maxWidth, kScreenWidth * 9 / 32)
                }
                
                let preferedHeight = scaleSize0.height
                
                for index in 0..<photoCount {
                    
                    let row = CGFloat(index / 2)
                    let column = CGFloat(index % 2)
                    let rect = CGRectMake(column * maxWidth, preferedHeight * row, maxWidth, preferedHeight)
                    resultRects[index] = rect
                }
                return(2 * preferedHeight, resultRects)
            }
            
            for index in 0..<photoCount {
                
                guard let photoSize = photoData[index].originalSize else {
                    continue
                }
                let originalSize = CGSizeMake(CGFloat(photoSize.width), CGFloat(photoSize.height))
                var scaledSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                if originalSize.width == 0 || originalSize.height == 0 {
                    scaledSize = CGSizeMake(kScreenWidth, kScreenWidth * 9 / 16)
                }
                let rect = CGRectMake(0, rectTop, kScreenWidth, scaledSize.height)
                rectTop += scaledSize.height
                resultRects[index] = rect
            }
            return(rectTop, resultRects)
        }



        return (0, [CGRectZero])
    }
    
    class func doLikeAnimation(cell : TumblrNormalCell, liked: Bool) {
        //找到相对于Window的frame，开始做动画
        
        let window = UIApplication.sharedApplication().delegate?.window!
        let likeBtn = cell.toolBarEntry.likeBtn
        let frameInCell = cell.toolBarEntry.convertRect(likeBtn.frame, toView: cell.contentView)
        let frameInWindow = cell.convertRect(frameInCell, toView: window)
        
        let size = frameInWindow.width
        
        //如果现在是喜欢的状态
        if liked {
            let animatedHeart = UIImageView()
            animatedHeart.size = CGSizeMake(48, 48)
            animatedHeart.contentMode = .ScaleAspectFill
            animatedHeart.image = UIImage(named: "icon_animated_like")
            animatedHeart.frame = frameInWindow
            animatedHeart.alpha = 0.6
            animatedHeart.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 9))
            animatedHeart.transform = CGAffineTransformScale(animatedHeart.transform, 0.75, 0.75)
            window?.addSubview(animatedHeart)
            
            let center = animatedHeart.center
            
            UIView.animateKeyframesWithDuration(0.7, delay: 0, options: [.CalculationModeLinear], animations: {
                
                UIView .addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: {
                    animatedHeart.alpha = 1.0
                    animatedHeart.transform = CGAffineTransformScale(animatedHeart.transform, 4/3.0, 4/3.0)
                    animatedHeart.center = CGPointMake(center.x - size * 0.1, center.y - size * 0.5)
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.5, animations: {
                    animatedHeart.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 8))
                    animatedHeart.center = CGPointMake(center.x, center.y - size * 1.8)
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.6, animations: {
                    animatedHeart.center = CGPointMake(center.x + size * 0.2, center.y - size * 2.6)
                    
                })
                
                UIView .addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.7, animations: {
                    animatedHeart.alpha = 0.3
                })
                
            }) { (finish) in
                animatedHeart.removeFromSuperview()
                
            }
            return
        }
        
        let centerX = frameInWindow.origin.x + size * 0.5
        
        let breakupTop = frameInWindow.origin.y - 2.5 * size
        let leftLeft = centerX - 28 + 5
        let rightLeft = centerX - 5
        
        //做不喜欢的动画
        let animatedLeft = UIImageView()
        animatedLeft.size = CGSizeMake(28, 48)
        animatedLeft.contentMode = .ScaleAspectFill
        animatedLeft.image = UIImage(named: "icon_animated_unlike_left")
        animatedLeft.frame = CGRectMake(leftLeft, breakupTop, 28, 48)
        window?.addSubview(animatedLeft)
        
        
        let animatedRight = UIImageView()
        animatedRight.size = CGSizeMake(28, 48)
        animatedRight.contentMode = .ScaleAspectFill
        animatedRight.image = UIImage(named: "icon_animated_unlike_right")
        animatedRight.frame = CGRectMake(rightLeft, breakupTop-1, 28, 48)
        window?.addSubview(animatedRight)
        
        let centerLeft = animatedLeft.center
        let centerRight = animatedRight.center
        
        
        UIView.animateKeyframesWithDuration(0.7, delay: 0, options: [.CalculationModeLinear], animations: {
            
            UIView .addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3, animations: {
                
                animatedLeft.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 16))
                animatedLeft.center = CGPointMake(centerLeft.x - 12, centerLeft.y)
                
                animatedRight.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 16))
                animatedRight.center = CGPointMake(centerRight.x + 12, centerRight.y)
                
            })
            
            UIView .addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.7, animations: {
                
                animatedLeft.center = CGPointMake(centerLeft.x - 12, centerLeft.y + 2 * size)
                animatedLeft.alpha = 0.0
                animatedRight.center = CGPointMake(centerRight.x + 12, centerRight.y + 2 * size)
                animatedRight.alpha = 0.0
                
            })
            
            
        }) { (finish) in
            animatedLeft.removeFromSuperview()
            animatedRight.removeFromSuperview()
            
        }
        
        
    }

}

