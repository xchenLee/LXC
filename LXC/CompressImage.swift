
//
//  CompressImage.swift
//  LXC
//
//  Created by renren on 16/5/10.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CompressImage: UIViewController {
    
    let display = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenW = AppDelegate.getAppDelegate().screenWidth
        display.frame = CGRectMake(60, 100, screenW - 120, (screenW - 120) * 3 / 2)
        display.contentMode = .ScaleAspectFit
        
        let inputImg = UIImage(named: "input.jpg")
        
        display.image = inputImg
        
        ToolBox.printImage(inputImg!)
        
        let newImg = ToolBox.imageCompressResolution(inputImg!, max: 1080)
        ToolBox.printImage(newImg)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
