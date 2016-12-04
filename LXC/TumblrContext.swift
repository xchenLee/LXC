//
//  TumblrContext.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit


let kTumblrUserArchiveKey: String = "kTumblrKey"


class TumblrContext: NSObject {
    
    
    fileprivate var tumblrUser : TumblrUser?
    
    
    static let sharedInstance = TumblrContext()
    /**
     to prevent others from using the default '()' initizlizer for this class.
     */
    fileprivate override init(){
    }
    
    func obtainTumblrUser() -> TumblrUser? {
        if let data = UserDefaults.standard.object(forKey: kTumblrUserArchiveKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? TumblrUser
        }
        return nil
    }
    
    func writeTumblrUser(_ user: TumblrUser) {
        let data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey: kTumblrUserArchiveKey)
        UserDefaults.standard.synchronize()
    }
    
}
