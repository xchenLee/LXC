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
     
     - parameter content: content
     */
    class func copytoPasteBoard(_ content: String) {
        if content.isEmpty {
            return
        }
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = content
    }
    
    
    class func obtainFloatPixel(_ pixel: CGFloat) -> CGFloat {
        return pixel / UIScreen.main.scale
    }
    
    
    // MARK: - Tool Methods to modify views
    class func makeNavigationBarAlpha(_ naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 0
    }
    
    class func makeNavigationBarAlphaNo(_ naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 1
    }
    
    class func radiansToDegrees(_ degree : UInt) -> CGFloat {
        return CGFloat(Double(degree) / M_PI * 180.0)
    }
    
    class func degreesToRadians(_ radian : UInt) -> CGFloat {
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
    
    class func dateFromString(_ timeString: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        guard let result = formatter.date(from: timeString) else {
            return Date()
        }
        return result
    }
    
    
    // MARK: - Tool for image
    class func printImage(_ input : UIImage) {
        
        let w = input.size.width
        let h = input.size.height
        
        NSLog("image resolution : \(w) * \(h)")
        
        let data = UIImageJPEGRepresentation(input, 1.0)
        
        NSLog("image length aflter UIImageJPEGRepresentation 1.0 : \(CGFloat((data?.count)! / 1024)) kb")
    }
    
    class func imageCompressResolution(_ input : UIImage, max : CGFloat) -> UIImage {
        
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
        
        let newSize = CGSize(width: newW, height: newH)
        UIGraphicsBeginImageContext(newSize)
        
        let newRect = CGRect(x: 0, y: 0, width: newW, height: newH)
        input.draw(in: newRect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg!
    }
    
    class func fitImageToSize(_ input : UIImage, w : CGFloat, h : CGFloat) -> UIImage {
        
        if w <= 0 || h >= 0 {
            return input
        }
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContext(newSize)
        
        let newRect = CGRect(x: 0, y: 0, width: w, height: h)
        input.draw(in: newRect)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg!
    }
    
    // MARK: -Tool for Quartz
    class func convertUIPointToQuartz(_ point : CGPoint, frameSize : CGSize) -> CGPoint {
        let convertY = frameSize.height - point.y
        return CGPoint(x: point.x, y: convertY)
    }
    
    class func scalePoint(_ point : CGPoint, previousSize : CGSize, currentSize : CGSize) -> CGPoint {
        let factor = currentSize.width / previousSize.width
        return CGPoint(x: factor * point.x, y: factor * point.y)
    }
    
    /**
     将原有Size根据，最大的Size等比压缩，生成新的Size
     
     - parameter original: <#original description#>
     - parameter max:      <#max description#>
     
     - returns: <#return value description#>
     */
    class func getScaleSize(_ original: CGSize, max: CGSize) -> CGSize {
        
        let width = max.width
        let scale = CGFloat(original.width) / CGFloat(width)
        var height = original.height / scale
        
        if height > max.height {
            height = max.height
        }
        return CGSize(width: width, height: height)
    }
    
    class func saveImgToSystemAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
}

