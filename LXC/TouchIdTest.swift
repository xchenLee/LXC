//
//  TouchIdTest.swift
//  LXC
//
//  Created by renren on 16/3/23.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIdTest: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        authenticateUser()
    }
    
    func authenticateUser() {
        //get the local authentication context
        let context = LAContext()
        //declare a NSError variable
        var error : NSError?
        
        //set the rease string that will appear on the authentication alert.La
        let reasonString = "Authentication is needed to complete the test"
        
        // check if the device can evaluate the policy
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, evalPolicyError) -> Void in
                
                if success {
                    print("Authentication was given by the user")
                } else {
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    print(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showOtherAlert()
                        })
                        
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showOtherAlert()
                        })
                    }
                }
            })
        } else {
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                print("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            self.showOtherAlert()
        }
    }
    
    func showOtherAlert() {
        
        let alertC = UIAlertController(title: "TouchIDDemo", message: "Touch not used", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
        }
        alertC.addAction(okayAction)
        presentViewController(alertC, animated: true, completion: nil)
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
