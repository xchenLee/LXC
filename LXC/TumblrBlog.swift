//
//  TumblrBlog.swift
//  LXC
//
//  Created by dreamer on 2017/6/2.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrBlog: UIViewController {
    
    public var blogName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    func customInit() {
        self.title = self.blogName ?? ""
        self.view.backgroundColor = kBackgroundColor
        self.navBarBackgroundAlpha = 0.0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
