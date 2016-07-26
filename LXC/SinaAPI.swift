//
//  SinaAPI.swift
//  LXC
//
//  Created by renren on 16/7/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Alamofire

/**
 
 http://open.weibo.com/wiki/2/statuses/friends_timeline/ids
 
 */

let kSinaDomain: String = "https://api.weibo.com/2/"
let kSinaPageSize : Int = 20

class SinaAPI: NSObject {
    
    
    enum WeiboType {
        case All, Original, Picture, Video, Music
    }
    
    class func obtainFullBusinessURL(businussUrl: String) -> String {
        return kSinaDomain + businussUrl
    }
    
    
    /**
     
     http://stackoverflow.com/questions/32355850/alamofire-invalid-value-around-character-0
     使用 requestJSON 会报错
     
     */
    
    class func requestUserData(accessToken: String, userId: String, completionHandler: Response<AnyObject, NSError> -> Void) {
        
        let business = "users/show.json"
        let urlString = SinaAPI.obtainFullBusinessURL(business)
        
        let parameters = [
            "access_token" : accessToken,
            "uid" : userId
        ]
        
        let request = Alamofire.request(.GET, urlString, parameters: parameters)
        
        request.responseJSON(completionHandler: completionHandler)
    }
    
    
    class func requestTimeline(sinceId: String?, page: Int, count: Int = kSinaPageSize, feature: WeiboType = .All,
                               completionHandler: Response<AnyObject, NSError> -> Void) {
        
        let business = "statuses/home_timeline/ids.json"
        let urlString = SinaAPI.obtainFullBusinessURL(business)
        
        let token = SinaContext.sharedInstance.user()!.accessToken
        let uid = SinaContext.sharedInstance.user()!.userId
        
        var parameters = [
            "access_token" : token,
            "uid" : uid
        ]
        if sinceId != nil {
            parameters["since_id"] = sinceId!
        }
        parameters["count"] = String(count)
        parameters["page"] = String(page)
        parameters["feautre"] = String(feature)
        
        let request = Alamofire.request(.GET, urlString, parameters: parameters)
        
        request.responseJSON(completionHandler: completionHandler)
        
    }


}








