//
//  SinaContext.swift
//  LXC
//
//  Created by renren on 16/7/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import RealmSwift

class SinaContext: NSObject {
    
    static let sharedInstance = SinaContext()
    /**
     to prevent others from using the default '()' initizlizer for this class.
     */
    private override init(){
    }

    
    private var sinaUser: SinaUser?
    
    func prepareForMigration() {
        
    }
    
    
    /**
     获取当前用户
     */
    func user() -> SinaUser? {
        
        guard let _ = sinaUser else {
            
            let realm = try! Realm()
            var results : Results<SinaUser>!
            
            results = realm.objects(SinaUser)
            //本地数据库没有存储
            if results.count == 0 {
                return nil
            }
            
            let user = results[0]
            
            let token = user.accessToken
            let expirationDate = user.expirationDate
            
            //token为空 或者token过期
            if token.isEmpty || expirationDate.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                return nil
            }
            sinaUser = user
            return sinaUser
        }
        
        return sinaUser
    }
    
    
    
}
