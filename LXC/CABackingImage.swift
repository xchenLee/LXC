//
//  CABackingImage.swift
//  LXC
//
//  Created by renren on 16/4/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CABackingImage: UIViewController {
    
    /**
     stackview
     
     https://www.raywenderlich.com/114552/uistackview-tutorial-introducing-stack-views
     
     collectionView
     
     https://www.raywenderlich.com/99087/swift-expanding-cells-ios-collection-views
     
     */

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewTwo: UIView!
    
    var imageLayer = CALayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w = viewTwo.bounds.size.width
        let h = viewTwo.bounds.size.height
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        
        imageLayer.frame = CGRect(x: (w - 100) / 2.0, y: (h - 100) / 2.0, width: 100, height: 100)
        imageLayer.backgroundColor = UIColor.white.cgColor
        viewTwo.layer.addSublayer(imageLayer)
        
        let image = UIImage(named: "tulin")
        imageLayer.contents = image?.cgImage
        
        //contentsGravity
        imageLayer.contentsGravity = kCAGravityCenter//kCAGravityResizeAspect
        //contentsScale
        imageLayer.contentsScale = UIScreen.main.scale
        //
        imageLayer.contentsScale = (image?.scale)!
        //contentsScale
        imageLayer.masksToBounds = true
        
        //contentsRect
        imageLayer.contentsRect = CGRect(x: 0, y: 0.5, width: 1, height: 0.5)
        
        //contentsRect的用法，就是image sprites,图片拼接到一张大图上一次性载入，
        //带来的好处是 内存使用，载入时间，渲染性能等
        
        //contentsCenter
        //这名字有些误导，其实它定义的是CGRect，layer中的可拉伸区域 default is (0,0,1,1)
        //它的作用和 -resizableImageWithCapInsets 一样,但是它可用于任何layer backing image
        //包括 drawn at runtime using Core Graphics
        
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
