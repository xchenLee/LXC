//
//  CABackingImage.swift
//  LXC
//
//  Created by renren on 16/4/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CABackingImage: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewTwo: UIView!
    
    var imageLayer = CALayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w = viewTwo.bounds.size.width
        let h = viewTwo.bounds.size.height
        imageLayer.frame = CGRect(x: (w - 100) / 2.0, y: (h - 100) / 2.0, width: 100, height: 100)
        imageLayer.backgroundColor = UIColor.whiteColor().CGColor
        viewTwo.layer.addSublayer(imageLayer)
        
        let image = UIImage(named: "tulin")
        imageLayer.contents = image?.CGImage
        
        //contentsGravity
        imageLayer.contentsGravity = kCAGravityCenter//kCAGravityResizeAspect
        //contentsScale
        imageLayer.contentsScale = UIScreen.mainScreen().scale
        //
        imageLayer.contentsScale = (image?.scale)!
        //contentsScale
        imageLayer.masksToBounds = true
        
        //contentsRect
        imageLayer.contentsRect = CGRectMake(0, 0, 0.5, 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
