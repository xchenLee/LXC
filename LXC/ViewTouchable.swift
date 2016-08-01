//
//  ViewTouchable.swift
//  LXC
//
//  Created by renren on 16/7/31.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import YYKit

class ViewTouchable: UIView {
    
    private var longPressDetected: Bool = false
    private var timer: NSTimer?
    private var point: CGPoint?

    
    private var image: UIImage?
    
    var touchBlock: ((ViewTouchable, YYGestureRecognizerState?, Set<UITouch>?, UIEvent?)-> Void)?
    
    var longPressBlock: ((ViewTouchable, CGPoint?) -> Void)?
    
    
    
    func displayImage(imageToSet: UIImage?) {
        self.image = imageToSet
        guard let safeImg = imageToSet else {
            self.layer.contents = nil
            return
        }
        self.layer.contents = safeImg.CGImage
        self.layer.contentsScale = UIScreen.screenScale()
    }
    
    func obtainDisplayImage() -> UIImage? {
        return self.image
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewTouchable.timerFire), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func endTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timerFire() {
        touchesCancelled(nil, withEvent: nil)
        longPressDetected = false
        if longPressBlock != nil {
            longPressBlock!(self, self.point)
        }
        self.endTimer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        longPressDetected = false
        if let safeTouchBlock = touchBlock {
            safeTouchBlock(self, .Began, touches, event)
        }
        if let safeLongTouchBlock = longPressBlock {
            let touch = touches.first
            self.point = touch?.locationInView(self)
            safeLongTouchBlock(self, self.point)
            self.startTimer()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if longPressDetected {
            return
        }
        if let safeTouchBlock = touchBlock {
            safeTouchBlock(self, .Moved, touches, event)
        }
        self.endTimer()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if longPressDetected {
            return
        }
        if let safeTouchBlock = touchBlock {
            safeTouchBlock(self, .Ended, touches, event)
        }
        self.endTimer()
        
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        if longPressDetected {
            return
        }
        if let safeTouchBlock = touchBlock {
            safeTouchBlock(self, .Cancelled, touches, event)
        }
        self.endTimer()
    }
    
    deinit {
        self.endTimer()
    }
}
