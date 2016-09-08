//
//  Extensions+UIViewController.swift
//  LXC
//
//  Created by renren on 16/8/4.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import MBProgressHUD

let kNavigationBackBtnColor = UIColor.whiteColor()

extension UIViewController {
    
    // MARK: - HUD
    
    /**
     显示加载样式
     */
    func showLoadingHUD() {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        hud.mode = .Indeterminate
        hud.removeFromSuperViewOnHide = true
        hud.show(true)
    }
    
    /**
     显示文本样式
     
     - parameter string: 展示的文本
     */
    func showTextHUD(string: String) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        hud.mode = .Text
        hud.labelText = string
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
    }
    
    /**
     隐藏
     */
    func hideHUD() {
        dispatch_async(dispatch_get_main_queue()) { 
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    
}