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

class SignInNormal: UIViewController, UITextFieldDelegate {

        
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var tumblrBtn: UIButton!
    
    var oauthswift: OAuth1Swift?
    
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.inputField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Auth btn click actions
    @IBAction func authBtnClicked(_ sender: AnyObject) {
        
        /*guard let authRequest : WBAuthorizeRequest = WBAuthorizeRequest.request() as? WBAuthorizeRequest else {
            return
        }
        
        authRequest.redirectURI = kWeiboRedirectURL
        authRequest.scope = "all"
        
        //        SinalTool.requestUserData("", userId: "")
        WeiboSDK.sendRequest(authRequest)*/

    }

    @IBAction func tumblrClicked(_ sender: AnyObject) {
        
        
        oauthswift = OAuth1Swift(
            consumerKey: kTumblrConsumerKey,
            consumerSecret: kTumblrConsumerSecretKey,
            requestTokenUrl: kTumblrRequestTokenUrl,
            authorizeUrl: kTumblrAuthorizeUrl,
            accessTokenUrl: kTumblrAccessTokenUrl
        )
        
        let handle = oauthswift!.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/tumblr")!,
            success: { credential, response, parameters in
                
                let token = credential.oauthToken
                let tokenSecret = credential.oauthTokenSecret
                
                TMAPIClient.sharedInstance().oAuthToken = token
                TMAPIClient.sharedInstance().oAuthTokenSecret = tokenSecret
                
                //begin
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
                        
                        TumblrContext.sharedInstance.writeTumblrUser(user)
                        ControllerJumper.login(nil)
                    }
                    
                })
                //end
                
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )

    }

}
