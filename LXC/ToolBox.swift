//
//  ToolBox.swift
//  LXC
//
//  Created by renren on 16/4/20.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Foundation

/**
 
 https://pages.github.com 建博客教程
 
 */

class ToolBox: NSObject {
    
    /**
     黏贴到黏贴板
     
     - parameter content: <#content description#>
     */
    class func copytoPasteBoard(content: String) {
        if content.isEmpty {
            return
        }
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = content
    }
    
    class func obtainFloatPixel(pixel: CGFloat) -> CGFloat {
        return pixel / UIScreen.mainScreen().scale
    }
    
    // MARK: - Tool for making
    
    // MARK: - Tool Methods to modify views
    class func makeNavigationBarAlpha(naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 0
    }
    
    class func makeNavigationBarAlphaNo(naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 1
    }
    
    class func radiansToDegrees(degree : UInt) -> CGFloat {
        return CGFloat(Double(degree) / M_PI * 180.0)
    }
    
    class func degreesToRadians(radian : UInt) -> CGFloat {
        return CGFloat( Double(radian) / 180.0 * M_PI)
    }
    
    class func randomBool() -> Bool {
        return arc4random() % 2 == 1
    }
    
    
    class func randomColor() -> UIColor {
        
        let hue : CGFloat = ( CGFloat(arc4random() % 256) / 256.0)
        let saturation : CGFloat =  ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let brightness : CGFloat =  ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0);
    }
    
    class func dateFromString(timeString: String) -> NSDate {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        guard let result = formatter.dateFromString(timeString) else {
            return NSDate()
        }
        return result
        
//        var date : NSDate?
//        do {
//            let range = NSRange(location: 0, length: timeString.characters.count)
//            
//            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
//            
//            detector.enumerateMatchesInString(timeString, options: NSMatchingOptions.Anchored, range: range, usingBlock: { (result, flags, ss) in
//                date = result?.date
//            })
//            return date!
//        }
//        catch {
//            return NSDate()
//        }
        
    }
    
    
    // MARK: - Tool for image
    class func printImage(input : UIImage) {
        
        let w = input.size.width
        let h = input.size.height
        
        NSLog("image resolution : \(w) * \(h)")
        
        let data = UIImageJPEGRepresentation(input, 1.0)
        
        NSLog("image length aflter UIImageJPEGRepresentation 1.0 : \(CGFloat((data?.length)! / 1024)) kb")
    }
    
    class func imageCompressResolution(input : UIImage, max : CGFloat) -> UIImage {
        
        let scale = input.scale
        let originalW = input.size.width
        let originalH = input.size.height
        
        if originalW <= max && originalH <= max {
            return input
        }
        
        var newW = max
        var newH = max
        
        if originalW > originalH {
            newH = newW * originalH / originalW
        } else {
            newW = newH * originalW / originalH
        }
        
        let newSize = CGSizeMake(newW, newH)
        UIGraphicsBeginImageContext(newSize)
        
        let newRect = CGRectMake(0, 0, newW, newH)
        input.drawInRect(newRect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
    }
    
    class func fitImageToSize(input : UIImage, w : CGFloat, h : CGFloat) -> UIImage {
        
        if w <= 0 || h >= 0 {
            return input
        }
        let newSize = CGSizeMake(w, h)
        UIGraphicsBeginImageContext(newSize)
        
        let newRect = CGRectMake(0, 0, w, h)
        input.drawInRect(newRect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
    }
    
    // MARK: -Tool for Quartz
    class func convertUIPointToQuartz(point : CGPoint, frameSize : CGSize) -> CGPoint {
        let convertY = frameSize.height - point.y
        return CGPointMake(point.x, convertY)
    }
    
    class func scalePoint(point : CGPoint, previousSize : CGSize, currentSize : CGSize) -> CGPoint {
        let factor = currentSize.width / previousSize.width
        return CGPointMake(factor * point.x, factor * point.y)
    }
    
    class func getScaleSize(original: CGSize, max: CGSize) -> CGSize {
        
        let width = max.width
        let scale = CGFloat(original.width) / CGFloat(width)
        var height = original.height / scale
        
        if height > max.height {
            height = max.height
        }
        return CGSizeMake(width, height)
    }
    
}


























