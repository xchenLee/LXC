//
//  Extensions.swift
//  LXC
//
//  Created by renren on 16/4/12.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

//import SwiftyDB
import UIKit

extension UIColor {
    
    class func rgbColor(hexValue : UInt, alpha : CGFloat) -> UIColor {
        return
            UIColor(
                red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(hexValue & 0x0000FF) / 255.0,
                alpha: alpha
        )
    }
    
}

//extension LoginKey : PrimaryKeys {
//    
//    class func primaryKeys() -> Set<String> {
//        return ["keyId", "keyUsername"]
//    }
//}
//
//extension LoginKey : IgnoredProperties {
//    
//    class func ignoredProperties() -> Set<String> {
//        return []
//    }
//}
