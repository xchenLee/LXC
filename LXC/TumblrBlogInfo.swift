//
//  TumblrBlogInfo.swift
//  LXC
//
//  Created by danlan on 2017/6/12.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit
import SwiftyJSON

struct TumblrBlogInfo {
    
    var posts: Int = 0
    var title: String = ""
    var name: String = ""
    var updated: Int = 0
    var description: String = ""
    
    var isAskAllowed: Bool = false
    var shareLikes: Bool = false
    var isBlocked: Bool = false
    var canSubscribe: Bool = false
    var url: String = ""
    var isFollow: Bool = false
    

    mutating func sjMap(_ json: JSON) {
        
        let blog = json["blog"]
        posts = blog["posts"].intValue
        title = blog["title"].stringValue
        name = blog["name"].stringValue
        
        updated = blog["updated"].intValue
        
        description = blog["description"].stringValue
        isAskAllowed = blog["ask"].boolValue
        shareLikes = blog["share_likes"].boolValue
        
        canSubscribe = blog["can_subscribe"].boolValue
        url = blog["url"].stringValue
        isFollow = blog["followed"].boolValue
    }
}



