//
//  DigitalScale.swift
//  LXC
//
//  Created by renren on 16/3/17.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class DigitalScale: UIViewController {
    
    var titleLabel = UILabel()
    var forceLabel = UILabel()
    var centerView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.bounds.size.width
        let height = self.view.bounds.size.height
        
        let viewWidth = width - 40;
        
        titleLabel.frame = CGRect(x: 0, y: 50, width: width, height: 20)
        titleLabel.font = UIFont.systemFontOfSize(18, weight:UIFontWeightLight)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Place item below"
        self.view.addSubview(titleLabel)
        
        centerView.frame = CGRect(x: (width - viewWidth) / 2, y: (height - viewWidth) / 2, width: viewWidth, height: viewWidth)
        centerView.contentMode = UIViewContentMode.ScaleAspectFill
        centerView.image = UIImage(named: "Touch")
        self.view.addSubview(centerView)
        
        forceLabel.frame = CGRect(x: 0, y: height - 50, width: width, height: 20)
        forceLabel.font = UIFont.systemFontOfSize(18, weight:UIFontWeightLight)
        forceLabel.textAlignment = NSTextAlignment.Center
        forceLabel.text = "0 gram"
        self.view.addSubview(forceLabel)
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                    if touch.force >= touch.maximumPossibleForce {
                        forceLabel.text = "385+ grams"
                    } else {
                        let force = touch.force/touch.maximumPossibleForce
                        let grams = force * 385
                        let roundGrams = Int(grams)
                        forceLabel.text = "\(roundGrams) grams"
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        forceLabel.text = "0 gram"
    }
}








