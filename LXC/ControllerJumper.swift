//
//  ControllerJumper.swift
//  LXC
//
//  Created by renren on 16/7/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kStoryboardNameMain = "Main"
let kStoryboardNameLogin = "SignIn"

class ControllerJumper: NSObject {
    
    
    /**
     检查是否登录，决定用户首次可见页面
     */
    class func afterLaunch(params :Dictionary<String, AnyObject>?) {
        
//        let jumpToMain = ToolBox.randomBool()
        let jumpToMain = false;
        
        let kRootStoryboardName = jumpToMain ? kStoryboardNameMain : kStoryboardNameLogin
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        
        AppDelegate.getAppDelegate().window = window
        
        let storyboard = UIStoryboard(name: kRootStoryboardName, bundle: NSBundle.mainBundle())
        
        guard let rootController = storyboard.instantiateInitialViewController(), keyWindow = AppDelegate.getAppDelegate().window else {
                return
        }
        
        keyWindow.rootViewController = rootController
        keyWindow.makeKeyAndVisible()
        
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
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        
        guard let window = AppDelegate.getAppDelegate().window, rootController = storyboard.instantiateInitialViewController() else {
            return
        }
        
        window.rootViewController = rootController
    }

}
