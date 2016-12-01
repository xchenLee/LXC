//
//  TumblrAPI.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Alamofire
import TMTumblrSDK
import OAuthSwift

let kTumblrAPIUrl = "https://api.tumblr.com/v2/"
let kTumblrThirdScheme = "iTumblr"

let kTumblrConsumerKey = "JWN0BIo6P7yF8HNNaa0Dy0lwKCHnQ01d5KcSnvxungjvtRVNce"
let kTumblrConsumerSecretKey = "wiNo4z5MsZ18YnRIMzzXSMrpCIQTaAeiv6GWqGxBxLDsC3XfBx"

let kTumblrAuthorizeUrl = "https://www.tumblr.com/oauth/authorize"
let kTumblrRequestTokenUrl = "https://www.tumblr.com/oauth/request_token"
let kTumblrAccessTokenUrl = "https://www.tumblr.com/oauth/access_token"


class TumblrAPI: NSObject {
    
    
    class func obtainFullBusinessURL(_ businussUrl: String) -> String {
        return kTumblrAPIUrl + businussUrl
    }
    
    class func registerApp() {
        
        TMAPIClient.sharedInstance().oAuthConsumerKey = kTumblrConsumerKey
        TMAPIClient.sharedInstance().oAuthConsumerSecret = kTumblrConsumerSecretKey
    }
    
    
    class func authorize(success: OAuth1Swift.TokenSuccessHandler, failure: OAuth1Swift.FailureHandler) {
     
     
        let oauthswift = OAuth1Swift(
            consumerKey: kTumblrConsumerKey,
            consumerSecret: kTumblrConsumerSecretKey,
            requestTokenUrl: kTumblrRequestTokenUrl,
            authorizeUrl: kTumblrAuthorizeUrl,
            accessTokenUrl: kTumblrAccessTokenUrl
        )
        
        let url: URL = URL(string: "oauth-swift://oauth-swift/tumblr")!
        //oauthswift.authorize(withCallbackURL: url, success: OAuthSwift.TokenSuccessHandler, failure: <#T##OAuthSwift.FailureHandler?##OAuthSwift.FailureHandler?##(OAuthSwiftError) -> Void#>)
     
    }

}


















