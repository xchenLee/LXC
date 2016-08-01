//
//  TumblrUser.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class TumblrUser: Object, Mappable {
    
// Specify properties to ignore (Realm won't persist these)
    
    var token = ""
    var tokenSecret = ""
    
    var following = 0

    var likes = 0
    var name = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
    

}
