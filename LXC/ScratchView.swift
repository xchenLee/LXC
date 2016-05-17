//
//  ScratchView.swift
//  LXC
//
//  Created by renren on 16/5/16.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import QuartzCore

let kBruchDefaultSize : CGFloat = 25.0

class ScratchView: UIView {

    var brushSize   : CGFloat = kBruchDefaultSize
    
    var bonusView   : UIView? {
        didSet {
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            
            let scale = UIScreen.mainScreen().scale
            
            UIGraphicsBeginImageContextWithOptions((bonusView?.bounds.size)!, false, 0)
            
            bonusView?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            bonusView?.layer.contentsScale = scale
            
            bonusImage = UIGraphicsGetImageFromCurrentImageContext().CGImage
            UIGraphicsEndImageContext()
            
            let imageW = CGImageGetWidth(bonusImage)
            let imageH = CGImageGetWidth(bonusImage)
            
            let pixels = CFDataCreateMutable(nil, imageW * imageH)
            contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(pixels), imageW, imageH, 8, imageW, colorSpace, 0)
            
            let provider = CGDataProviderCreateWithCFData(pixels)
            
            CGContextSetFillColorWithColor(contextMask, UIColor.blackColor().CGColor);
            CGContextFillRect(contextMask, CGRectMake(0, 0, self.frame.size.width * scale, self.frame.size.height * scale));
            
            
            CGContextSetStrokeColorWithColor(contextMask, UIColor.whiteColor().CGColor);
            CGContextSetLineWidth(contextMask, kBruchDefaultSize);
            CGContextSetLineCap(contextMask, .Round);
            
            let mask = CGImageMaskCreate(imageW, imageH, 8, 8, imageW, provider, nil, false);
            bonusImage = CGImageCreateWithMask(bonusImage, mask);
        }
    }
    
    
    private var previousTouchLocation : CGPoint = CGPointZero
    private var currentTouchLocation  : CGPoint = CGPointZero
    
    private var bonusImage      : CGImageRef?
    private var contextMask     : CGContextRef?
    private var movementView    :  UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.opaque = false
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let any = event?.touchesForView(self)
        if let touch = any?.first {
            currentTouchLocation = touch.locationInView(self)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let any = event?.touchesForView(self)
        if let touch = any?.first {
            
            if !CGPointEqualToPoint(previousTouchLocation, CGPointZero) {
                currentTouchLocation = touch.locationInView(self)
            }
            
            previousTouchLocation = touch.preciseLocationInView(self)

            scratch(previousTouchLocation, endPoint: currentTouchLocation)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let any = event?.touchesForView(self)
        if let touch = any?.first {
            
            if !CGPointEqualToPoint(previousTouchLocation, CGPointZero) {
                previousTouchLocation = touch.preciseLocationInView(self)
                scratch(previousTouchLocation, endPoint: currentTouchLocation)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        
    }
    
    func scratch(startPoint : CGPoint, endPoint : CGPoint) {
        
        let scale = UIScreen.mainScreen().scale
        
        CGContextMoveToPoint(contextMask, startPoint.x * scale, (self.frame.size.height - startPoint.y) * scale)
        CGContextAddLineToPoint(contextMask, endPoint.x * scale, (self.frame.size.height - endPoint.y) * scale)
        CGContextStrokePath(contextMask);
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if bonusImage != nil {
            let drawImg = UIImage(CGImage: bonusImage!)
            drawImg.drawInRect(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
        }
        
    }
    
}


























