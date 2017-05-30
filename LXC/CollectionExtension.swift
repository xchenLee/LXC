//
//  CollectionExtension.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func merge(dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            updateValue(value, forKey: key)
        }
    }
    
    
}

extension Array {
    
    func sub(position: Int) -> Array {
        let subArray = Array(self[0 ..< position])
        return subArray
    }
}
