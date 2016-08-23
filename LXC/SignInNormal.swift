//
//  SignInNormal.swift
//  LXC
//
//  Created by renren on 16/7/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TMTumblrSDK
import OAuthSwift
import SwiftyJSON
import ObjectMapper

class SignInNormal: UIViewController, UITextFieldDelegate {

        
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var tumblrBtn: UIButton!
    
    
    
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.inputField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Subscribe events
    func subscribe() {
        let text = inputField.rx_text
        text.subscribeNext { (text) in
            
        }
    }
    
    
    
    // MARK: - Auth btn click actions
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
