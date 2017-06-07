//
//  TumblrContext.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK


let kTumblrUserArchiveKey: String = "kTumblrKey"


class TumblrContext: NSObject {
    
    
    fileprivate var tumblrUser : TumblrUser?
    
    
    static let shared = TumblrContext()
    /**
     to prevent others from using the default '()' initizlizer for this class.
     */
    fileprivate override init(){
    }
    
    
    /**
     *  文件中读取user数据
     */
    func read() -> TumblrUser? {
        if let data = UserDefaults.standard.object(forKey: kTumblrUserArchiveKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? TumblrUser
        }
        return nil
    }
    
    
    /**
     * 写user数据
     */
    func store(_ user: TumblrUser) {
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey: kTumblrUserArchiveKey)
        UserDefaults.standard.synchronize()
    }
    
    /**
     * 将数据写个TumblrSDK, 因为有自动登录逻辑
     */
    func cache() {
        let cachedUser = TumblrContext.shared.read()
        guard let user = cachedUser else { return }
        TMAPIClient.sharedInstance().oAuthToken = user.token
        TMAPIClient.sharedInstance().oAuthTokenSecret = user.tokenSecret
    }
    
}











