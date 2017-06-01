//
//  NavigationWrapper.swift
//  LXC
//
//  Created by danlan on 2017/6/1.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

/**
 * 用于想推出一个独立的NavigationController的页面
 *
 */
class NavigationWrapper: UINavigationController {
    
    public var contentController: UIViewController? {
        
        didSet {
            if self.contentController != nil {
                self.addChildViewController(self.contentController!)
                self.contentController!.didMove(toParentViewController: self)
                self.view.addSubview(self.contentController!.view)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
















