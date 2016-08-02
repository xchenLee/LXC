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
    
    
    dynamic var token = ""
    dynamic var tokenSecret = ""
    
    dynamic var following = 0

    dynamic var likes = 0
    dynamic var name = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
    
    // Specify properties to ignore (Realm won't persist these)

    

}
