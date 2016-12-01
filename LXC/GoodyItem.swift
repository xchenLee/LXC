//
//  GoodyItem.swift
//  LXC
//
//  Created by renren on 16/3/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

enum PresentType : Int {
    case push
    case present
}

class GoodyItem: NSObject {
    
    var goodyName : String
    var goodyClassName : String
    var storyboardName : String
    
    var presetnType : PresentType
    
    init(name : String, goodyClassName : String) {
        self.goodyName = name
        self.goodyClassName = goodyClassName
        self.storyboardName = ""
        self.presetnType = .push
    }
    
    init(name : String, storyboardName : String) {
        self.goodyName = name
        self.goodyClassName = ""
        self.storyboardName = storyboardName
        self.presetnType = .push
    }

}
