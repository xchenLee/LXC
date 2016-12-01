//
//  Extensions+UIViewController.swift
//  LXC
//
//  Created by renren on 16/8/4.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import MBProgressHUD

let kNavigationBackBtnColor = UIColor.white

extension UIViewController {
    
    // MARK: - HUD
    
    /**
     显示加载样式
     */
    func showLoadingHUD() {
        
        let hud = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        hud?.mode = .indeterminate
        hud?.removeFromSuperViewOnHide = true
        hud?.show(true)
    }
    
    /**
     显示文本样式
     
     - parameter string: 展示的文本
     */
    func showTextHUD(_ string: String) {
        
        let hud = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        hud?.mode = .text
        hud?.labelText = string
        hud?.removeFromSuperViewOnHide = true
        hud?.hide(true, afterDelay: 2)
    }
    
    /**
     隐藏
     */
    func hideHUD() {
        DispatchQueue.main.async { 
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
}
