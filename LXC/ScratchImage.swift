//
//  ScratchImage.swift
//  LXC
//
//  Created by renren on 16/5/17.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class ScratchImage: UIViewController {
    
    
    var scratchView : ScratchView?
    var bonusView   : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRectMake(100, 100, 300, 700)
        
        bonusView = UILabel()
        bonusView?.frame = rect
        bonusView?.text = "sorry ,hahahahaha"
        self.view.addSubview(bonusView!)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "beauties")
        imageView.frame = rect
        self.view.addSubview(imageView)
        
        
        scratchView = ScratchView(frame: rect)
        scratchView?.bonusView = imageView
        self.view.addSubview(scratchView!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
