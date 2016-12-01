//
//  ResponsePosts.swift
//  LXC
//
//  Created by renren on 16/7/28.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponsePosts: Mappable {
    
    var posts: [TumblrPost]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        //liked_posts
        //posts
        posts <- map["liked_posts"]
    }

}
