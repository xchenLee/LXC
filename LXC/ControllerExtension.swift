//
//  ControllerExtension.swift
//  LXC
//
//  Created by dreamer on 2017/6/13.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func shake(_ count: Int) {
        
        let center = self.view.center
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = Float(count)
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 10, y: center.y)
        animation.fromValue = CGPoint(x: center.x + 10, y: center.y)
        self.view.layer.add(animation, forKey: "position")
    }
}
