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

class SignInNormal: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tumblrBtn: UIButton!
    
    var oauthswift: OAuth1Swift?
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tumblrClicked(_ sender: AnyObject) {
        
        
        oauthswift = OAuth1Swift(
            consumerKey: kTumblrConsumerKey,
            consumerSecret: kTumblrConsumerSecretKey,
            requestTokenUrl: kTumblrRequestTokenUrl,
            authorizeUrl: kTumblrAuthorizeUrl,
            accessTokenUrl: kTumblrAccessTokenUrl
        )
        
        oauthswift!.authorize(
            withCallbackURL: URL(string: kTumblrCallbackUrl)!,
            success: { credential, response, parameters in
                TumblrAPI.handleSuccess(credential, response, parameters)
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )

    }

}
