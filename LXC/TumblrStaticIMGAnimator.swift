//
//  TumblrStaticIMGAnimator.swift
//  LXC
//
//  Created by renren on 16/9/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrStaticIMGAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containView = transitionContext.containerView()!
    }
    
    
    
    
    

}
