//
//  TumblrAPI.swift
//  LXC
//
//  Created by renren on 16/7/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
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
    
    
    class func obtainFullBusinessURL(businussUrl: String) -> String {
        return kTumblrAPIUrl + businussUrl
    }
    
    class func registerApp() {
        
        TMAPIClient.sharedInstance().OAuthConsumerKey = kTumblrConsumerKey
        TMAPIClient.sharedInstance().OAuthConsumerSecret = kTumblrConsumerSecretKey
    }
    
    
    class func authorize(success: (credential: OAuthSwiftCredential, response: NSURLResponse?, parameters: Dictionary<String, String>) -> Void, failure: ((error: NSError) -> Void)?) {
     
     
     let oauthswift = OAuth1Swift(
        consumerKey: kTumblrConsumerKey,
        consumerSecret: kTumblrConsumerSecretKey,
        requestTokenUrl: kTumblrRequestTokenUrl,
        authorizeUrl: kTumblrAuthorizeUrl,
        accessTokenUrl: kTumblrAccessTokenUrl
     )
     
     oauthswift.authorizeWithCallbackURL(NSURL(string: "oauth-swift://oauth-swift/tumblr")!, success: success, failure: failure)
    
    }

}
