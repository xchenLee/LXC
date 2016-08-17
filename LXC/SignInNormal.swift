//
//  SignInNormal.swift
//  LXC
//
//  Created by renren on 16/7/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK
import OAuthSwift
import SwiftyJSON
import ObjectMapper

class SignInNormal: UIViewController {

    
    @IBOutlet weak var authBtn: UIButton!
    
    @IBOutlet weak var tumblrBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authBtnClicked(sender: AnyObject) {
        
        /*guard let authRequest : WBAuthorizeRequest = WBAuthorizeRequest.request() as? WBAuthorizeRequest else {
            return
        }
        
        authRequest.redirectURI = kWeiboRedirectURL
        authRequest.scope = "all"
        
        //        SinalTool.requestUserData("", userId: "")
        WeiboSDK.sendRequest(authRequest)*/

    }

    @IBAction func tumblrClicked(sender: AnyObject) {
        
        
        TumblrAPI.authorize({ (credential, response, parameters) in
            
            let token = credential.oauth_token
            let tokenSecret = credential.oauth_token_secret
            //let verifier = credential.oauth_verifier
            
            TMAPIClient.sharedInstance().OAuthToken = token
            TMAPIClient.sharedInstance().OAuthTokenSecret = tokenSecret
            
            TMAPIClient.sharedInstance().userInfo({ (result, error) in
                
                if error == nil {
                    
                    var response = JSON(result)
                    //let manThred = NSThread.currentThread() == NSThread.mainThread()
                                        
                    let user = TumblrUser()
                    user.token = token
                    user.tokenSecret = tokenSecret
                    user.name = response["user"]["name"].stringValue
                    user.likes = response["user"]["likes"].intValue
                    user.following = response["user"]["following"].intValue
                    
                    do {
                        let realm = TumblrContext.sharedInstance.obtainUIRealm()
                        try realm.write({
                            realm.add(user)
                        })
                        ControllerJumper.login(nil)
                    } catch {
                        
                    }
                } else {
                    
                }
                
            })
            
            }) { (error) in
                print("tumblr signin error")
        }
        
    }

}
