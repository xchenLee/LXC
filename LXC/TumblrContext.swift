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
    
    private var uiRealm : Realm?
    
    static let sharedInstance = TumblrContext()
    /**
     to prevent others from using the default '()' initizlizer for this class.
     */
    private override init(){
    }
    
    
    func obtainUIRealm() -> Realm {
        
        guard let realm = uiRealm else {
                        
        
//            let config = Realm.Configuration(
//                // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
//                schemaVersion: 2,
//            
//                // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
//                migrationBlock: { migration, oldSchemaVersion in
//                    // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
//                    if (oldSchemaVersion < 2) {
//                        // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
//                    }
//            })
//            Realm.Configuration.defaultConfiguration = config
//            
            do {
                try self.uiRealm = Realm()
            }
            catch let error as NSError{
                print("load Realm : \(error)")
            }

            

            return self.uiRealm!
        }
        
        return realm
        
    }
    
    /**
     获取当前用户
     */
    func user() -> TumblrUser? {
        
        guard let _ = tumblrUser else {
            
            let realm = TumblrContext.sharedInstance.obtainUIRealm()
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
