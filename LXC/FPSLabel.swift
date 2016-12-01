//
//  FPSLabel.swift
//  LXC
//
//  Created by renren on 16/9/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {

    fileprivate var caDisplayLink: CADisplayLink!
    fileprivate var count: Int = 0
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var llll: TimeInterval = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.frame = CGRect(x: 0, y: 0, width: 55, height: 25)
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.fromARGB(0x000000, alpha: 0.7)
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14)
        self.caDisplayLink = CADisplayLink(target: self, selector: #selector(tick))
        self.caDisplayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func tick(_ link: CADisplayLink) {
        
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

