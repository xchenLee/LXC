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
    class func afterLaunch(params :Dictionary<String, AnyObject>?) {
        
        let user = TumblrContext.sharedInstance.user()

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
    class func login(params :Dictionary<String, AnyObject>?) {
        
        loadController(kStoryboardNameMain)
    }
    
    /**
     退出登录
     */
    class func logout(params :Dictionary<String, AnyObject>?) {
        
        loadController(kStoryboardNameLogin)
    }
    
    class func loadController(storyboardName: String) {
        
        loadController(storyboardName, initWindow: false)
    }
    
    class func loadController(storyboardName: String, initWindow: Bool) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        
        if initWindow {
            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.backgroundColor = UIColor.whiteColor()
            AppDelegate.getAppDelegate().window = window
        }
        
        
        guard let window = AppDelegate.getAppDelegate().window, rootController = storyboard.instantiateInitialViewController() else {
            return
        }
        
        window.rootViewController = rootController
        if initWindow {
            window.makeKeyAndVisible()
        }
    }

}
