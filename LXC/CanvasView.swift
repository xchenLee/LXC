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
let kBrushColor : UIColor = UIColor.red

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
        self.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let events = event?.touches(for: self)
        
        if let eventTouch = events, let touch = eventTouch.first {
            
            let point = touch.location(in: self)
            
            let path = UIBezierPath()
            path.lineWidth = kBrushSize
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.move(to: point)
        
            self.movingPaths.append(path)
            
            NSLog("Begin: current location:\(point.x),\(point.y))")
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let events = event?.touches(for: self)
        
        if let eventTouch = events, let touch = eventTouch.first {
            
            let point = touch.location(in: self)
            //let previousPoint = touch.precisePreviousLocationInView(self)
            let lastPath = self.movingPaths.last
            lastPath?.addLine(to: point)
            
            self.setNeedsDisplay()
            
            NSLog("Move: current location:\(point.x),\(point.y))")
            
        }
    }
    
    
    func movePoint(_ from : CGPoint, to : CGPoint) {
    }
    
    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
        
        for path : UIBezierPath in self.movingPaths {
            kBrushColor.setStroke()
            path.stroke()
        }
    }
    

}
