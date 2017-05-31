//
//  TumblrAPI.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import TMTumblrSDK
import OAuthSwift
import SwiftyJSON

let kTumblrAPIUrl = "https://api.tumblr.com/v2/"
let kTumblrThirdScheme = "iTumblr"

let kTumblrConsumerKey = "JWN0BIo6P7yF8HNNaa0Dy0lwKCHnQ01d5KcSnvxungjvtRVNce"
let kTumblrConsumerSecretKey = "wiNo4z5MsZ18YnRIMzzXSMrpCIQTaAeiv6GWqGxBxLDsC3XfBx"

let kTumblrAuthorizeUrl = "https://www.tumblr.com/oauth/authorize"
let kTumblrRequestTokenUrl = "https://www.tumblr.com/oauth/request_token"
let kTumblrAccessTokenUrl = "https://www.tumblr.com/oauth/access_token"

let kTumblrCallbackUrl = "oauth-swift://oauth-callback/tumblr"


class TumblrAPI: NSObject {
    
    
    class func obtainFullBusinessURL(_ businussUrl: String) -> String {
        return kTumblrAPIUrl + businussUrl
    }
    
    class func registerApp() {
        
        TMAPIClient.sharedInstance().oAuthConsumerKey = kTumblrConsumerKey
        TMAPIClient.sharedInstance().oAuthConsumerSecret = kTumblrConsumerSecretKey
    }
    
    
    class func handleSuccess(_ credential: OAuthSwiftCredential, _ response: URLResponse?, _ parameters: [String: Any]) {
     
        let token = credential.oauthToken
        let tokenSecret = credential.oauthTokenSecret
        
        TMAPIClient.sharedInstance().oAuthToken = token
        TMAPIClient.sharedInstance().oAuthTokenSecret = tokenSecret
        
        //begin
        TMAPIClient.sharedInstance().userInfo({ (result, error) in
            
            if error == nil {
                
                var response = JSON(result!)
                
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
    }

}

