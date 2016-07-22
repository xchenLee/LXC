//
//  SinalTool.swift
//  LXC
//
//  Created by renren on 16/7/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Alamofire

let kSinaDomain: String = "https://api.weibo.com/2/"

class SinalTool: NSObject {
    
    class func obtainFullBusinessURL(certainBusiness: String) -> String{
        return kSinaDomain + certainBusiness
    }
    
    
    class func requestUserData(token: NSString, userId: NSString) {
        
//        let business = "users/show"
        //SinalTool.obtainFullBusinessURL(business)
        
    }
    
}
