//
//  UIColor+ARGB.swift
//  LXC
//
//  Created by renren on 16/3/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func fromARGB(rgb : Int, alpha : Float) ->UIColor {
        let red   =  CGFloat(rgb & 0xFF0000 >> 16) / 255.0
        let green =  CGFloat(rgb & 0x00FF00 >>  8) / 255.0
        let blue  =  CGFloat(rgb & 0x0000FF >>  0) / 255.0
        let alph  =  CGFloat(alpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alph)
    }
    
}






















