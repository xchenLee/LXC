//
//  Extensions+UIView.swift
//  LXC
//
//  Created by renren on 16/7/30.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

extension UIView {
    
    var centerX : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width / 2
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width / 2
        }
    }
    
    var centerY : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height / 2
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height / 2
        }
    }
    
    var origin : CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            self.frame.origin = newValue
        }
    }
    
    var size : CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var right : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    
    
}