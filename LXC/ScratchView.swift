//
//  ScratchView.swift
//  LXC
//
//  Created by renren on 16/5/23.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class ScratchView: UIView {

    
    var previousPoint : CGPoint?
    var currentPoint  : CGPoint?
    var bonusImage    : CGImageRef?
    var scratchImage  : CGImageRef?
    var contextMask   : CGContextRef?
    
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
    
    func addMaskView(mask : UIView) {
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        
        mask.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        mask.layer.contentsScale = scale
        
        bonusImage = UIGraphicsGetImageFromCurrentImageContext().CGImage
        
        UIGraphicsEndImageContext()
        
        let imageW = CGImageGetWidth(bonusImage)
        let imageH = CGImageGetHeight(bonusImage)
        
        let pixels = CFDataCreateMutable(nil, imageW * imageH)
        
        contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(pixels), imageW, imageH , 8, imageW, colorSpace, 0)
        let dataProvider = CGDataProviderCreateWithCFData(pixels);
        
        CGContextSetFillColorWithColor(contextMask, UIColor.blackColor().CGColor);
        CGContextFillRect(contextMask, CGRectMake(0, 0, self.frame.size.width * scale, self.frame.size.height * scale));
        
        
        CGContextSetStrokeColorWithColor(contextMask, UIColor.whiteColor().CGColor);
        CGContextSetLineWidth(contextMask, 12);
        CGContextSetLineCap(contextMask, .Round);
        
        let mask = CGImageMaskCreate(imageW, imageH, 8, 8, imageW, dataProvider, nil, false);
        scratchImage = CGImageCreateWithMask(bonusImage, mask);
        
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let imageToDraw = UIImage(CGImage: self.scratchImage!)
        imageToDraw.drawInRect(CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height))
    }
    
    
    // MARK: - Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let touchesForView = event?.touchesForView(self)
        if let touch = touchesForView?.first {
            currentPoint = touch.locationInView(self)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let touchesForView = event?.touchesForView(self)
        if let touch = touchesForView?.first {
            currentPoint = touch.locationInView(self)
            previousPoint = touch.previousLocationInView(self)
            self.scratchView(previousPoint!, endPoint: currentPoint!)
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touchesForView = event?.touchesForView(self)
        if let touch = touchesForView?.first {
            previousPoint = touch.previousLocationInView(self)
            self.scratchView(previousPoint!, endPoint: currentPoint!)
        }
    }
    
    
    func scratchView(startPoint : CGPoint, endPoint : CGPoint) {
        
        let scale = UIScreen.mainScreen().scale
        
        CGContextMoveToPoint(contextMask, startPoint.x * scale, (self.frame.size.height - startPoint.y) * scale);
        CGContextAddLineToPoint(contextMask, endPoint.x * scale, (self.frame.size.height - endPoint.y) * scale);
        CGContextStrokePath(contextMask)
        
        self.setNeedsDisplay()

    }

}
