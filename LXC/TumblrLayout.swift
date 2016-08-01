//
//  TumblrLayout.swift
//  LXC
//
//  Created by renren on 16/7/30.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrLayout: NSObject {
    
    
    var post : TumblrPost? {
        
        didSet {
            //设置过了,
            if post != oldValue {
                self.layout()
            }
        }
    }
    
    
    var height : CGFloat = 0
    
    
    
    func reset() {
        height = 0
        
    }
    
    
    func layout() {
        
    }
    
    
    

}
