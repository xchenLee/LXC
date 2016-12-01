//
//  TumblrStaticIMGAnimator.swift
//  LXC
//
//  Created by renren on 16/9/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrStaticIMGAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containView = transitionContext.containerView
    }
    
    
    
    
    

}
