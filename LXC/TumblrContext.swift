//
//  TumblrContext.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import RealmSwift

class TumblrContext: NSObject {
    
    
    private var tumblrUser : TumblrUser?
    
    static let sharedInstance = TumblrContext()
    /**
     to prevent others from using the default '()' initizlizer for this class.
     */
    private override init(){
    }
    
    
    /**
     获取当前用户
     */
    func user() -> TumblrUser? {
        
        guard let _ = tumblrUser else {
            
            let realm = try! Realm()
            var results : Results<TumblrUser>!
            
            results = realm.objects(TumblrUser)
            //本地数据库没有存储
            if results.count == 0 {
                return nil
            }
            
            let user = results[0]
            
            //token为空 或者token过期
            if user.token.isEmpty || user.tokenSecret.isEmpty {
                return nil
            }
            tumblrUser = user
            return tumblrUser
        }
        
        return tumblrUser
    }



}
