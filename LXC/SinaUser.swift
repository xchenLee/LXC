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
    
    var userId = ""
    var accessToken = ""
    var refreshToken = ""
    var expirationDate = NSDate()
    
    
    var friendsCount = 0
    var followersCount = 0
    var favouritesCount = 0
    var createdAt = NSDate()
    
    
    var avatarLarge = ""
    var sinaDescription = ""
    var location = ""
    var url = ""
    var profileImageUrl = ""
    var gender = ""
    var screenName = ""
    var name = ""
    var coverImage = ""

    
    
    
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
