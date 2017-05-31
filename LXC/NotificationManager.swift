//
//  NotificationManager.swift
//  LXC
//
//  Created by lxc on 2017/5/26.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    // MARK: - 单例方法
    static let shared = NotificationManager()

    
    // MARK: - 申请通知权限
    func apply(completion: @escaping (Bool) -> Void) {
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            //还没决定, 去申请
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                    completion(granted)
                })
            }
        }
    }
    
}
