//
//  TumblrPage.swift
//  LXC
//
//  Created by lxc on 2017/5/27.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

let kSegTabHeight: CGFloat = 40.0

class TumblrPage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    func customInit() {
        
        self.title = "blog"
        self.view.backgroundColor = UIColor.white
        
        let segTitles = ["Posts", "Likes"]
        let control = LJSegControl(segTitles)
        control.indicatorHeight = 3.0
        control.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kSegTabHeight)
        self.view.addSubview(control)
        
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
