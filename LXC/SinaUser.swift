//
//  SinaUser.swift
//  LXC
//
//  Created by renren on 16/7/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class SinaUser: Object {
    
    dynamic var userId = ""
    dynamic var accessToken = ""
    dynamic var refreshToken = ""
    dynamic var expirationDate = NSDate()
    
    
    dynamic var friendsCount = 0
    dynamic var followersCount = 0
    dynamic var favouritesCount = 0
    dynamic var createdAt = NSDate()
    
    
    dynamic var avatarLarge = ""
    dynamic var sinaDescription = ""
    dynamic var location = ""
    dynamic var url = ""
    dynamic var profileImageUrl = ""
    dynamic var gender = ""
    dynamic var screenName = ""
    dynamic var name = ""
    dynamic var coverImage = ""

    
    
    
    /*class func constructFromResponse(response : WBAuthorizeResponse) -> SinaUser {
        
        let user = SinaUser()
        user.accessToken = response.accessToken
        user.refreshToken = response.refreshToken
        user.expirationDate = response.expirationDate
        user.userId = response.userID
        return user
    }*/
    
    func parseFromUserJSON(json : JSON) {
        
        if json.isEmpty {
            return
        }
        self.name = json["name"].stringValue


        self.screenName = json["screen_name"].stringValue
        self.sinaDescription = json["description"].stringValue
        self.friendsCount = json["friends_count"].intValue
        self.followersCount = json["followers_count"].intValue
        
        self.gender = json["gender"].stringValue
        self.avatarLarge = json["avatar_large"].stringValue
        self.url = json["url"].stringValue
        
        let createdAtString = json["created_at"].stringValue
        
        self.createdAt =  ToolBox.dateFromString(createdAtString)
        
        self.profileImageUrl = json["profile_image_url"].stringValue
        
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
