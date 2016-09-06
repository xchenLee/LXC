//
//  FPSLabel.swift
//  LXC
//
//  Created by renren on 16/9/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {

    private var caDisplayLink: CADisplayLink!
    private var count: Int = 0
    private var lastTime: NSTimeInterval = 0
    private var llll: NSTimeInterval = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.frame = CGRectMake(0, 0, 55, 25)
        self.textAlignment = NSTextAlignment.Center
        self.userInteractionEnabled = false
        self.backgroundColor = UIColor.fromARGB(0x000000, alpha: 0.7)
        self.textColor = UIColor.whiteColor()
        self.font = UIFont.systemFontOfSize(14)
        self.caDisplayLink = CADisplayLink(target: self, selector: #selector(tick))
        self.caDisplayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func tick(link: CADisplayLink) {
        
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        self.count += 1
        
        let delta = link.timestamp - self.lastTime
        if delta < 1 {
            return
        }
        self.lastTime = link.timestamp
        let fps: Float = Float(self.count) / Float(delta)
        self.count = 0
        
        self.text = "\(round(fps)) FPS"
    }

}

