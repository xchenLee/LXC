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
let kTMWriteIconSize : CGFloat = 48


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
let kTMCellVideoSourceFlagSize : CGFloat = 40


/// 文字
let kTMCellTitleFontSize : CGFloat = 20
let kTMCellTitleFontColor = UIColor.fromARGB(0x646464, alpha: 1.0)
let kTMCellTitleFont = UIFont.systemFont(ofSize: kTMCellTitleFontSize, weight: UIFontWeightRegular)

let kTMCellTextFontSize: CGFloat = 14
let kTMCellTextFontColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellTextFont = UIFont.systemFont(ofSize: kTMCellTextFontSize, weight: UIFontWeightLight)


let kTMCellLineColor = UIColor.fromARGB(0xDCDCDC, alpha: 1.0)
let kTMCellLineColorAlpha = UIColor.fromARGB(0xDCDCDC, alpha: 0.5)

let kTMCellBlogNameFontSize : CGFloat = 14
let kTMCellBlogNameTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellBlogNameFont = UIFont.systemFont(ofSize: kTMCellBlogNameFontSize, weight: UIFontWeightLight)

let kTMCellReblogFontSize : CGFloat = 14
let kTMCellReblogTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellReblogFont = UIFont.systemFont(ofSize: kTMCellReblogFontSize, weight: UIFontWeightLight)

let kTMCellTagFontSize : CGFloat = 14
let kTMCellTagTextColor = UIColor.fromARGB(0x292f33, alpha: 1.0)
let kTMCellTagFont = UIFont.systemFont(ofSize: kTMCellTagFontSize, weight: UIFontWeightLight)



let kTMCellAvatarAreaHeight = kTMCellAvatarSize + kTMCellPadding * 2
let kTMCellToolBarHeight : CGFloat = 40

/// 图片足最大高度，不超过一屏可见高度
let kTMCellPhotoMaxHeight = kScreenHeight - 68
let kTMCellPhotoMaxWidth = kScreenWidth

let kTMCellPhotoMaxSize = CGSize(width: kTMCellPhotoMaxWidth, height: kTMCellPhotoMaxHeight)


let kDebugMaxAllowedPhotoCount = 10

class LayoutManager: NSObject {
    
    
    class func getTagsAttributedString(_ text: String) -> NSAttributedString {
        
        
        /*let attributedString = text.convertToAttributedString(kTMCellTextFont, textColor: kTMCellTextFontColor)
                
        let textRange = NSMakeRange(0, attributedString.length)
        
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: kTMCellTagTextColor, range: textRange)
        attributedString.addAttribute(NSFontAttributeName, value: kTMCellTagFont, range: textRange)
        
        */
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let textRange = NSMakeRange(0, (text as NSString).length)

        
        let expression = try! NSRegularExpression(pattern: kCustomDetectionTagPattern, options: [])
        
        expression.enumerateMatches(in: text, options: [], range: textRange) { (result, flags, stop) in
            
            guard let matchingResult = result else {
               return
            }
            
            let startIndex = text.characters.index(text.startIndex, offsetBy: matchingResult.range.location)
            let lastIndex = text.characters.index(text.startIndex, offsetBy: matchingResult.range.location + matchingResult.range.length)
            let range = startIndex..<lastIndex
            
            let matchedString = text.substring(with: range) as NSString
            
            let attributes: [String : Any] = [
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
    class func getTextEntryTextAttributedString(_ text: String) -> NSAttributedString {
        
        //获取转化HTML过后的AS
        let mutableAS = text.convertToAttributedString(kTMCellTextFont, textColor: kTMCellTextFontColor)
        
        //开始添加自定义属性，段落，
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
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
    class func getReblogEntryTextAttributedString(_ text: String) -> NSAttributedString {
        
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
    class func computeBlogNameWidth(_ blogName: String) -> CGFloat {
        
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
    class func computeRelogHeight(_ blogName: NSAttributedString) -> CGFloat {
        
        let height = blogName.heightWithConstrainedWidth(kScreenWidth - 2 * kTMCellPadding)

        return height
    }
    
    class func computeTagsHeight(_ tagsText: NSAttributedString) -> CGFloat {
        
        let height = tagsText.heightWithConstrainedWidth(kScreenWidth - 2 * kTMCellPadding)
        
        return height + kTMCellPadding
    }
    
    
    /**
     计算图片大小，并返回布局信息
     
     - parameter photos: 图片数据
     
     - returns: 元组包含（整个图片控件高度,[imageView的布局]）
     */
    class func computeImagesHeight(_ photos: [Photo]?) ->  (CGFloat,[CGRect]) {
        
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
                return (0,[CGRect.zero])
            }
            if realSize.width == 0 || realSize.height == 0 {
                let width = kScreenWidth
                let height = kScreenWidth * 9 / 16
                return(height, [CGRect(x: 0, y: 0, width: width, height: height)])
            }
            
            let originalSize = CGSize(width: CGFloat(realSize.width), height: CGFloat(realSize.height))
            let scaleSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
            
            let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: scaleSize.height)
            return (scaleSize.height,[rect])
        }
        
        if photoCount == 2 {
            
            let photoSize0 = photoData[0].originalSize
            let photoSize1 = photoData[1].originalSize

            guard let realSize0 = photoSize0, let realSize1 = photoSize1 else {
                return (0, Array<CGRect>(repeating: CGRect.zero, count: photoCount))
            }
            //如果第一张宽度大于高度就竖直排列
            let vertical = realSize0.width > realSize0.height
            

            
            if vertical {
                
                let originalSize0 = CGSize(width: CGFloat(realSize0.width), height: CGFloat(realSize0.height))
                
                var scaleSize0 = ToolBox.getScaleSize(originalSize0, max: kTMCellPhotoMaxSize)
                
                if originalSize0.width == 0 || originalSize0.height == 0 {
                    scaleSize0 = CGSize(width: kScreenWidth, height: kScreenWidth * 9 / 16)
                }
                
                let originalSize1 = CGSize(width: CGFloat(realSize1.width), height: CGFloat(realSize1.height))
                var scaleSize1 = ToolBox.getScaleSize(originalSize1, max: kTMCellPhotoMaxSize)
                
                if originalSize1.width == 0 || originalSize1.height == 0 {
                    scaleSize1 = CGSize(width: kScreenWidth, height: kScreenWidth * 9 / 16)
                }
                
                let height = scaleSize0.height + scaleSize1.height
                
                let rect0 = CGRect(x: 0, y: 0, width: kScreenWidth, height: scaleSize0.height)
                
                let rect1 = CGRect(x: 0, y: scaleSize0.height, width: kScreenWidth, height: scaleSize1.height)
                
                return (height,[rect0, rect1])
            } else {
                
                let minOriginalHeight = min(realSize0.height, realSize1.height)
                var pairedWidth = realSize0.width
                if minOriginalHeight == realSize1.height {
                    pairedWidth = realSize1.width
                }
                
                let originalSize = CGSize(width: CGFloat(pairedWidth), height: CGFloat(minOriginalHeight))
                let maxSize = CGSize(width: kScreenWidth / 2, height: kTMCellPhotoMaxHeight / 2)
                let scaleSize = ToolBox.getScaleSize(originalSize, max: maxSize)
                
                let rect0 = CGRect(x: 0, y: 0, width: kScreenWidth / 2, height: scaleSize.height)
                
                let rect1 = CGRect(x: kScreenWidth / 2, y: 0, width: kScreenWidth / 2, height: scaleSize.height)
                return (scaleSize.height,[rect0, rect1])
            }
        }
        
        
        if photoCount == 3 {
            
            var resultRects = Array<CGRect>(repeating: CGRect.zero, count: photoCount)
            
            guard let _ = photoData[0].originalSize else {
                return (0, resultRects)
            }
            
            var rectTop: CGFloat = 0
            for index in 0..<photoCount {
                
                guard let photoSize = photoData[index].originalSize else {
                    continue
                }
                let originalSize = CGSize(width: CGFloat(photoSize.width), height: CGFloat(photoSize.height))
                var scaledSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                if originalSize.width == 0 || originalSize.height == 0 {
                    scaledSize = CGSize(width: kScreenWidth, height: kScreenWidth * 9 / 16)
                }
                let rect = CGRect(x: 0, y: rectTop, width: kScreenWidth, height: scaledSize.height)
                rectTop += scaledSize.height
                resultRects[index] = rect
            }
            return(rectTop, resultRects)
        }
        
        if photoCount >= 4 && photoCount % 2 == 0{
            
            var resultRects = Array<CGRect>(repeating: CGRect.zero, count: photoCount)
            
            guard let photoSize0 = photoData[0].originalSize else {
                return (0, resultRects)
            }
            
            var rectTop: CGFloat = 0

            if CGFloat(photoSize0.width) < kScreenWidth {
                //第一张宽度小于屏幕宽度,就两张并列放置
                
                let maxWidth = kScreenWidth / 2
                
                let originalSize0 = CGSize(width: CGFloat(photoSize0.width), height: CGFloat(photoSize0.height))
                var scaleSize0 = ToolBox.getScaleSize(originalSize0, max: CGSize(width: maxWidth, height: kTMCellPhotoMaxHeight / 2))
                if originalSize0.width == 0 || originalSize0.height == 0 {
                    scaleSize0 = CGSize(width: maxWidth, height: kScreenWidth * 9 / 32)
                }
                
                let preferedHeight = scaleSize0.height
                
                for index in 0..<photoCount {
                    
                    let row = CGFloat(index / 2)
                    let column = CGFloat(index % 2)
                    let rect = CGRect(x: column * maxWidth, y: preferedHeight * row, width: maxWidth, height: preferedHeight)
                    resultRects[index] = rect
                }
                return(CGFloat(photoCount / 2) * preferedHeight, resultRects)
            }
            
            for index in 0..<photoCount {
                
                guard let photoSize = photoData[index].originalSize else {
                    continue
                }
                let originalSize = CGSize(width: CGFloat(photoSize.width), height: CGFloat(photoSize.height))
                var scaledSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                if originalSize.width == 0 || originalSize.height == 0 {
                    scaledSize = CGSize(width: kScreenWidth, height: kScreenWidth * 9 / 16)
                }
                let rect = CGRect(x: 0, y: rectTop, width: kScreenWidth, height: scaledSize.height)
                rectTop += scaledSize.height
                resultRects[index] = rect
            }
            return(rectTop, resultRects)
        }

        if photoCount > 4 && photoCount % 2 == 1 {
            
            var resultRects = Array<CGRect>(repeating: CGRect.zero, count: photoCount)
            //TODO
            var rectTop: CGFloat = 0
            
            for index in 0..<photoCount {
                
                guard let photoSize = photoData[index].originalSize else {
                    continue
                }
                let originalSize = CGSize(width: CGFloat(photoSize.width), height: CGFloat(photoSize.height))
                var scaledSize = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                if originalSize.width == 0 || originalSize.height == 0 {
                    scaledSize = CGSize(width: kScreenWidth, height: kScreenWidth * 9 / 16)
                }
                let rect = CGRect(x: 0, y: rectTop, width: kScreenWidth, height: scaledSize.height)
                rectTop += scaledSize.height
                resultRects[index] = rect
            }
            return(rectTop, resultRects)
        }

        return (0, [CGRect.zero])
    }
    
    class func doLikeAnimation(_ cell : TumblrNormalCell, liked: Bool) {
        //找到相对于Window的frame，开始做动画
        
        let window = UIApplication.shared.delegate?.window!
        let likeBtn = cell.toolBarEntry.likeBtn
        let frameInCell = cell.toolBarEntry.convert(likeBtn.frame, to: cell.contentView)
        let frameInWindow = cell.convert(frameInCell, to: window)
        
        let size = frameInWindow.width
        
        //如果现在是喜欢的状态
        if liked {
            let animatedHeart = UIImageView()
            animatedHeart.size = CGSize(width: 48, height: 48)
            animatedHeart.contentMode = .scaleAspectFill
            animatedHeart.image = UIImage(named: "icon_animated_like")
            animatedHeart.frame = frameInWindow
            animatedHeart.alpha = 0.6
            animatedHeart.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI / 9))
            animatedHeart.transform = animatedHeart.transform.scaledBy(x: 0.75, y: 0.75)
            window?.addSubview(animatedHeart)
            
            let center = animatedHeart.center
            
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                
                UIView .addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                    animatedHeart.alpha = 1.0
                    animatedHeart.transform = animatedHeart.transform.scaledBy(x: 4/3.0, y: 4/3.0)
                    animatedHeart.center = CGPoint(x: center.x - size * 0.1, y: center.y - size * 0.5)
                })
                
                UIView .addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5, animations: {
                    animatedHeart.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 8))
                    animatedHeart.center = CGPoint(x: center.x, y: center.y - size * 1.8)
                })
                
                UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.6, animations: {
                    animatedHeart.center = CGPoint(x: center.x + size * 0.2, y: center.y - size * 2.6)
                    
                })
                
                UIView .addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.7, animations: {
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
        animatedLeft.size = CGSize(width: 28, height: 48)
        animatedLeft.contentMode = .scaleAspectFill
        animatedLeft.image = UIImage(named: "icon_animated_unlike_left")
        animatedLeft.frame = CGRect(x: leftLeft, y: breakupTop, width: 28, height: 48)
        window?.addSubview(animatedLeft)
        
        
        let animatedRight = UIImageView()
        animatedRight.size = CGSize(width: 28, height: 48)
        animatedRight.contentMode = .scaleAspectFill
        animatedRight.image = UIImage(named: "icon_animated_unlike_right")
        animatedRight.frame = CGRect(x: rightLeft, y: breakupTop-1, width: 28, height: 48)
        window?.addSubview(animatedRight)
        
        let centerLeft = animatedLeft.center
        let centerRight = animatedRight.center
        
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
            
            UIView .addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                
                animatedLeft.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI / 16))
                animatedLeft.center = CGPoint(x: centerLeft.x - 12, y: centerLeft.y)
                
                animatedRight.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 16))
                animatedRight.center = CGPoint(x: centerRight.x + 12, y: centerRight.y)
                
            })
            
            UIView .addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
                
                animatedLeft.center = CGPoint(x: centerLeft.x - 12, y: centerLeft.y + 2 * size)
                animatedLeft.alpha = 0.0
                animatedRight.center = CGPoint(x: centerRight.x + 12, y: centerRight.y + 2 * size)
                animatedRight.alpha = 0.0
                
            })
            
            
        }) { (finish) in
            animatedLeft.removeFromSuperview()
            animatedRight.removeFromSuperview()
            
        }
    }

}

