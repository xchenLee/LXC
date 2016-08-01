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
import RealmSwift
import OAuthSwift


let kNavigationBarTintColor = UIColor.fromARGB(0x1A1B1C,alpha: 1.0)
let kBackgroundColor = UIColor.fromARGB(0xF5F5F2,alpha: 1.0)

let kScreenWidth = UIScreen.mainScreen().bounds.size.width
let kScreenHeight = UIScreen.mainScreen().bounds.size.height



let kWeiboAppKey = "2721785301"
let kWeiboAppSecret = "8b70ac89dfaa01cf68a9654639cf6750"
let kWeiboRedirectURL = "https://api.weibo.com/oauth2/default.html"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {//,WeiboSDKDelegate

    var window: UIWindow?
    
    
    
    lazy var contactStore = CNContactStore()
    
    /*lazy var screenWidth : CGFloat = {
        return UIScreen.mainScreen().bounds.size.width
    }()
    
    lazy var screenHeight : CGFloat = {
       return UIScreen.mainScreen().bounds.size.height
    }()*/


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //注册本地通知
        registerLocationNotification()
        
        //WeiboSDK.registerApp(kWeiboAppKey)
        TumblrAPI.registerApp()
        
        var isLaunchedFromQuickAction = false
        
        //根据数据库里的存储数据跳转
        ControllerJumper.afterLaunch(nil)
        
        //因为token, tokenSecret是没次取完之后自己维护的，客户端登录后需要从缓存拿出来
        if let user = TumblrContext.sharedInstance.user() {
            TMAPIClient.sharedInstance().OAuthToken = user.token
            TMAPIClient.sharedInstance().OAuthTokenSecret = user.tokenSecret
        }
        
        
        guard let options = launchOptions, _ = options[UIApplicationLaunchOptionsShortcutItemKey] as?
            UIApplicationShortcutItem  else {
            return true
        }
        
        isLaunchedFromQuickAction = true

        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        completionHandler(handleQuickAction(shortcutItem))
        
    }
    
    func handleQuickAction(shortcutItem : UIApplicationShortcutItem) -> Bool{
        var quickActionHandled = false
        let quickAction = shortcutItem.type.componentsSeparatedByString(".").last
        if quickAction == "QRReader" {
            let visibleController = self.window?.rootViewController
            if (visibleController is UINavigationController) {
                let navigationController = visibleController as! UINavigationController
                let qrReaderController = UIStoryboard(name: "qrStoryboard", bundle: NSBundle.mainBundle()).instantiateInitialViewController()! as UIViewController
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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
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

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        //分发给登录页面
        let visibleController = self.window?.rootViewController
        if let videoBackground = visibleController as? VideoBackground {
            videoBackground.avPlayer?.play()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //
        NSLog("receive location notification")
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if identifier == "actionOne" {
            NSLog("one")
        } else if identifier == "actionTwo" {
            NSLog("two")
        }
        completionHandler()
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //return WeiboSDK.handleOpenURL(url, delegate: self)
        
        if (url.host == "oauth-swift") {
            OAuthSwift.handleOpenURL(url)
        }

        return true
    }
    
    
    // MARK: - Custom Methods
    
    // MARK: - WeiboSDKDelegate
    /*func didReceiveWeiboResponse(response: WBBaseResponse!) {
        
        if let authResponse  = response as? WBAuthorizeResponse {
            
            let sinaUser = SinaUser.constructFromResponse(authResponse)
            
            SinaAPI.requestUserData(sinaUser.accessToken ,userId:sinaUser.userId, completionHandler:{ response in
                
                
                var responseJSON : JSON
                
                if response.result.isFailure {
                    responseJSON = JSON.null
                } else {
                    responseJSON = JSON(response.result.value!)
                }
                
                sinaUser.parseFromUserJSON(responseJSON)
                
                do {
                    try uiRealm.write({
                        uiRealm.add(sinaUser)
                    })
                }
                catch let error as NSError{
                    print("store login sina user error : \(error)")
                }
                //跳往首页面
                ControllerJumper.login(nil)
            })
        }
        
    }
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }*/
    
    // MARK: - 决定加载主页面

    // MARK: -
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func registerLocationNotification() {
        
        //如果有，不再重复设置
        let notificationSettings : UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        if (notificationSettings != nil) {
            return
        }
        
        let actionOne = UIMutableUserNotificationAction()
        actionOne.identifier = "actionOne"
        actionOne.title = "Action One"
        actionOne.activationMode = UIUserNotificationActivationMode.Background
        actionOne.destructive = false
        actionOne.authenticationRequired = false
        
        let actionTwo = UIMutableUserNotificationAction()
        actionTwo.identifier = "actionTwo"
        actionTwo.title = "Action Two"
        actionTwo.activationMode = UIUserNotificationActivationMode.Foreground
        actionTwo.destructive = false
        actionTwo.authenticationRequired = true
        
        let actionThr = UIMutableUserNotificationAction()
        actionThr.identifier = "actionThr"
        actionThr.title = "Action Thr"
        actionThr.activationMode = UIUserNotificationActivationMode.Background
        actionThr.destructive = true
        actionThr.authenticationRequired = true
        
        //let actionsArray : [UIUserNotificationAction] = NSArray(objects: actionOne, actionTwo, actionThr) as! [UIUserNotificationAction]
        
        let categoryOne = UIMutableUserNotificationCategory()
        categoryOne.identifier = "categoryOne"
        //categoryOne.setActions(actionsArray, forContext: UIUserNotificationActionContext.Default)
        categoryOne.setActions([actionOne, actionTwo], forContext: UIUserNotificationActionContext.Minimal)
        
        let categoryForSetting = Set<UIUserNotificationCategory>(arrayLiteral: categoryOne)

        //var notificationTypes : UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
        let settings = UIUserNotificationSettings(forTypes:[.Alert, .Badge, .Sound], categories: categoryForSetting)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    //请求通讯录数据
    func requestContactsAccess(completionHandler : (accessGranted : Bool) -> Void) {
        
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
        case .Denied , .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: true)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            //self.showMessage(message)
                        })
                    }
                }
            })
        default:
            completionHandler(accessGranted: false)
        }
        
    }
    
    // MARK: -获取自定义相册
    func obtainSystemAssetCollection(completionHandler: (assetCollection:PHAssetCollection) -> Void){
        
        let albumTitle = "LXC"
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumTitle)
        
        let fetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        // find the album collection
        if let fetchedCollection = fetchResult.firstObject {
            completionHandler(assetCollection: fetchedCollection as! PHAssetCollection)
            return
        }
        
        // not found  then create it
        var assetCollectionIdentifier : String = ""
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            let createAlbumRequest =  PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumTitle)
            assetCollectionIdentifier = createAlbumRequest.placeholderForCreatedAssetCollection.localIdentifier
            }) { (success, error) -> Void in
                
                if (success) {
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([assetCollectionIdentifier], options: nil)
                    if let resultCollection = collectionFetchResult.firstObject {
                        completionHandler(assetCollection: resultCollection as! PHAssetCollection)
                    }
                }
        }
    }

}

