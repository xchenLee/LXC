//
//  SignInNormal.swift
//  LXC
//
//  Created by renren on 16/7/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class SignInNormal: UIViewController {

    
    @IBOutlet weak var authBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authBtnClicked(sender: AnyObject) {
                
        guard let authRequest : WBAuthorizeRequest = WBAuthorizeRequest.request() as? WBAuthorizeRequest else {
            return
        }
        
        authRequest.redirectURI = kWeiboRedirectURL
        authRequest.scope = "all"
        
        //        SinalTool.requestUserData("", userId: "")
        WeiboSDK.sendRequest(authRequest)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
