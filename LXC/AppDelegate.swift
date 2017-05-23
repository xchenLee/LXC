//
//  AppDelegate.swift
//  LXC
//
//  Created by renren on 16/2/24.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Contacts
import Photos
import SwiftyJSON
import Alamofire
import TMTumblrSDK
import OAuthSwift
import UserNotifications


let kNavigationBarTintColor = UIColor.fromARGB(0x1A1B1C,alpha: 1.0)
let kBackgroundColor = UIColor.fromARGB(0xF5F5F2,alpha: 1.0)

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    lazy var contactStore = CNContactStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //注册本地通知
        //registerLocationNotification()
        
        TumblrAPI.registerApp()
        
        //var isLaunchedFromQuickAction = false
        
        //根据数据库里的存储数据跳转
        ControllerJumper.afterLaunch(nil)
        
        //因为token, tokenSecret是没次取完之后自己维护的，客户端登录后需要从缓存拿出来
        if let user = TumblrContext.sharedInstance.obtainTumblrUser() {
            TMAPIClient.sharedInstance().oAuthToken = user.token
            TMAPIClient.sharedInstance().oAuthTokenSecret = user.tokenSecret
        }
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        guard let options = launchOptions, let _ = options[UIApplicationLaunchOptionsKey.shortcutItem] as?
            UIApplicationShortcutItem  else {
            return true
        }
        
        //isLaunchedFromQuickAction = true

        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleQuickAction(shortcutItem))
        
    }
    
    func handleQuickAction(_ shortcutItem : UIApplicationShortcutItem) -> Bool{
        var quickActionHandled = false
        let quickAction = shortcutItem.type.components(separatedBy: ".").last
        if quickAction == "QRReader" {
            let visibleController = self.window?.rootViewController
            if (visibleController is UINavigationController) {
                let navigationController = visibleController as! UINavigationController
                let qrReaderController = UIStoryboard(name: "qrStoryboard", bundle: Bundle.main).instantiateInitialViewController()! as UIViewController
                navigationController.pushViewController(qrReaderController, animated: true)
            }
        }
        /*let type = shortcutItem.type.componentsSeparatedByString(".").last!
        if let shortcutType = Shortcut.init(rawValue: type) {
            switch shortcutType {
            case .openBlue:
                self.window?.backgroundColor = UIColor(red: 151.0/255.0, green: 187.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                quickActionHandled = true
            }
        }*/
        quickActionHandled = true
        return quickActionHandled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //分发给登录页面
        let visibleController = self.window?.rootViewController
        if visibleController is VideoBackground {
            
        }
        
        if let videoBackground = visibleController as? VideoBackground {
            videoBackground.avPlayer?.pause()
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        //分发给登录页面
        let visibleController = self.window?.rootViewController
        if let videoBackground = visibleController as? VideoBackground {
            videoBackground.avPlayer?.play()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("userNotificationCenter # didReceive ")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("userNotificationCenter # willPresent ")
    }

    
    /*func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        if identifier == "actionOne" {
            NSLog("one")
        } else if identifier == "actionTwo" {
            NSLog("two")
        }
        completionHandler()
    }*/
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //return WeiboSDK.handleOpenURL(url, delegate: self)
        
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }

        return true
    }
    
    
    // MARK: - 决定加载主页面

    // MARK: -
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /*
    func registerLocationNotification() {
        
        //如果有，不再重复设置
        let notificationSettings : UIUserNotificationSettings! = UIApplication.shared.currentUserNotificationSettings
        if (notificationSettings != nil) {
            return
        }
        
        let actionOne = UIMutableUserNotificationAction()
        actionOne.identifier = "actionOne"
        actionOne.title = "Action One"
        actionOne.activationMode = UIUserNotificationActivationMode.background
        actionOne.isDestructive = false
        actionOne.isAuthenticationRequired = false
        
        let actionTwo = UIMutableUserNotificationAction()
        actionTwo.identifier = "actionTwo"
        actionTwo.title = "Action Two"
        actionTwo.activationMode = UIUserNotificationActivationMode.foreground
        actionTwo.isDestructive = false
        actionTwo.isAuthenticationRequired = true
        
        let actionThr = UIMutableUserNotificationAction()
        actionThr.identifier = "actionThr"
        actionThr.title = "Action Thr"
        actionThr.activationMode = UIUserNotificationActivationMode.background
        actionThr.isDestructive = true
        actionThr.isAuthenticationRequired = true
        
        //let actionsArray : [UIUserNotificationAction] = NSArray(objects: actionOne, actionTwo, actionThr) as! [UIUserNotificationAction]
        
        let categoryOne = UIMutableUserNotificationCategory()
        categoryOne.identifier = "categoryOne"
        //categoryOne.setActions(actionsArray, forContext: UIUserNotificationActionContext.Default)
        categoryOne.setActions([actionOne, actionTwo], for: UIUserNotificationActionContext.minimal)
        
        let categoryForSetting = Set<UIUserNotificationCategory>(arrayLiteral: categoryOne)

        //var notificationTypes : UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
        let settings = UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: categoryForSetting)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }*/
    
    //请求通讯录数据
    func requestContactsAccess(_ completionHandler : @escaping (_ accessGranted : Bool) -> Void) {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied , .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(true)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            //let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            //self.showMessage(message)
                        })
                    }
                }
            })
        default:
            completionHandler(false)
        }
        
    }
    
    // MARK: -获取自定义相册
    func obtainSystemAssetCollection(_ completionHandler: @escaping (_ assetCollection:PHAssetCollection) -> Void){
        
        let albumTitle = "LXC"
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumTitle)
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        // find the album collection
        if let fetchedCollection = fetchResult.firstObject {
            completionHandler(fetchedCollection )
            return
        }
        
        // not found  then create it
        var assetCollectionIdentifier : String = ""
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let createAlbumRequest =  PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumTitle)
            assetCollectionIdentifier = createAlbumRequest.placeholderForCreatedAssetCollection.localIdentifier
            }) { (success, error) -> Void in
                
                if (success) {
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionIdentifier], options: nil)
                    if let resultCollection = collectionFetchResult.firstObject {
                        completionHandler(resultCollection )
                    }
                }
        }
    }

}

