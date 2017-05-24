//
//  TumblrUser.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation

class TumblrUser: NSObject, NSCoding {
    
    dynamic var name = ""
    dynamic var token = ""
    dynamic var tokenSecret = ""
    
    dynamic var following = 0
    dynamic var likes = 0
    
    override init() {
        
    }
    
    // MARK: - NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.tokenSecret, forKey: "tokenSecret")
        aCoder.encode(self.likes, forKey: "likes")
        aCoder.encode(self.following, forKey: "following")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.tokenSecret = aDecoder.decodeObject(forKey: "tokenSecret") as! String
        self.likes = aDecoder.decodeInteger(forKey: "likes")
        self.following = aDecoder.decodeInteger(forKey: "following")
    }
    

}












