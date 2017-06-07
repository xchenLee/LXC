//
//  ControllerJumper.swift
//  LXC
//
//  Created by renren on 16/7/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kStoryboardNameMain = "tumblrboard"
let kStoryboardNameLogin = "SignIn"

class ControllerJumper: NSObject {
    
    
    /**
     检查是否登录，决定用户首次可见页面
     */
    class func afterLaunch(_ params :Dictionary<String, AnyObject>?) {
        
        let user = TumblrContext.shared.read()
        guard let _ = user else {
            //传递过来的User为空
            loadController(kStoryboardNameLogin, initWindow: true)
            return
        }
        loadController(kStoryboardNameMain, initWindow: true)
    }
    
    /**
     退出登录
     */
    class func login(_ params :Dictionary<String, AnyObject>?) {
        
        loadController(kStoryboardNameMain)
    }
    
    /**
     退出登录
     */
    class func logout(_ params :Dictionary<String, AnyObject>?) {
        
        loadController(kStoryboardNameLogin)
    }
    
    class func loadController(_ storyboardName: String) {
        
        loadController(storyboardName, initWindow: false)
    }
    
    class func loadController(_ storyboardName: String, initWindow: Bool) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        
        if initWindow {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.white
            AppDelegate.shared().window = window
        }
        
        guard let window = AppDelegate.shared().window, let rootController = storyboard.instantiateInitialViewController() else {
            return
        }
        
        window.rootViewController = rootController
        
        if initWindow {
            window.makeKeyAndVisible()
        }
    }

}
