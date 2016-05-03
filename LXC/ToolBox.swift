//
//  ToolBox.swift
//  LXC
//
//  Created by renren on 16/4/20.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

/**
 
 https://pages.github.com 建博客教程
 
 */

class ToolBox: NSObject {
    
    // MARK: - Tool for making
    
    // MARK: - Tool Methods to modify views
    class func makeNavigationBarAlpha(naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 0
    }
    
    class func makeNavigationBarAlphaNo(naviController : UINavigationController) {
        
        let subViews = naviController.navigationBar.subviews
        
        let viewOne = subViews[0]
        
        viewOne.alpha = 1
    }
    
    class func radiansToDegrees(degree : UInt) -> CGFloat {
        return CGFloat(Double(degree) / M_PI * 180.0)
    }
    
    class func degreesToRadians(radian : UInt) -> CGFloat {
        return CGFloat( Double(radian) / 180.0 * M_PI)
    }
    
}


























