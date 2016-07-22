//
//  SinaUser.swift
//  LXC
//
//  Created by renren on 16/7/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import RealmSwift

class SinaUser: Object {
    
    dynamic var userName = ""
    dynamic var userId = ""
    dynamic var accessToken = ""
    dynamic var refreshToken = ""
    dynamic var expirationDate = NSDate()
    
    
    class func constructFromResponse(response : WBAuthorizeResponse) -> SinaUser {
        
        let user = SinaUser()
        user.accessToken = response.accessToken
        user.refreshToken = response.refreshToken
        user.expirationDate = response.expirationDate
        user.userId = response.userID
        return user
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
