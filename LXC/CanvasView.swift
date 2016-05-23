//
//  CanvasView.swift
//  LXC
//
//  Created by renren on 16/5/23.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import QuartzCore

let kBrushSize  : CGFloat = 8
let kBrushColor : UIColor = UIColor.redColor()

class CanvasView: UIView {
    
    var currentTouchLocation : CGPoint?
    var movingPaths : [UIBezierPath] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let events = event?.touchesForView(self)
        
        if let eventTouch = events, let touch = eventTouch.first {
            
            let point = touch.locationInView(self)
            
            let path = UIBezierPath()
            path.lineWidth = kBrushSize
            path.lineJoinStyle = .Round
            path.lineCapStyle = .Round
            path.moveToPoint(point)
        
            self.movingPaths.append(path)
            
            NSLog("Begin: current location:\(point.x),\(point.y))")
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let events = event?.touchesForView(self)
        
        if let eventTouch = events, let touch = eventTouch.first {
            
            let point = touch.locationInView(self)
            //let previousPoint = touch.precisePreviousLocationInView(self)
            let lastPath = self.movingPaths.last
            lastPath?.addLineToPoint(point)
            
            self.setNeedsDisplay()
            
            NSLog("Move: current location:\(point.x),\(point.y))")
            
        }
    }
    
    
    func movePoint(from : CGPoint, to : CGPoint) {
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for path : UIBezierPath in self.movingPaths {
            kBrushColor.setStroke()
            path.stroke()
        }
    }
    

}
