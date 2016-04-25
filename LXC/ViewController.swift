//
//  ViewController.swift
//  LXC
//
//  Created by renren on 16/2/24.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let videoBackground = VideoBackground()
        //self.view .addSubview(videoBackground.view)
        
        let digitalScale = DigitalScale()
        self.view .addSubview(digitalScale.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

