//
//  TumblrUser.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import ObjectMapper

class TumblrUser:NSObject, Mappable, NSCoding {
    
    
    dynamic var token = ""
    dynamic var tokenSecret = ""
    
    dynamic var following = 0

    dynamic var likes = 0
    dynamic var name = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    
    // MARK: - NSCoding
    public func encode(with aCoder: NSCoder) {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.tokenSecret = aDecoder.decodeObject(forKey: "tokenSecret") as! String
    }
    

}












