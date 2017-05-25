//
//  CALayerTree.swift
//  LXC
//
//  Created by renren on 16/4/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CALayerTree: UIViewController {

    @IBOutlet weak var fatherView: UIView!
    
    @IBOutlet weak var sonView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func addLayer(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        let newLayer = CALayer()
        newLayer.backgroundColor = fatherView.backgroundColor?.cgColor
        newLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        newLayer.position = sonView.center
        
        
        // visual effects
//        newLayer.shadowOpacity = 0.5
//        newLayer.shadowColor = UIColor.blackColor().CGColor
//        newLayer.shadowRadius = 3
//        newLayer.shadowOffset = CGSizeMake(0, 3)

        
        sonView.layer.addSublayer(newLayer)
        
        // 如果想要 shadow view.layer.masksToBounds = false 或者 view.clipsToBounds = false
        // 这里并不要用可能是因为是storyboard写的
        // 需要在storyboard 里边设置
        // visual effects
        sonView.layer.shadowOpacity = 1
        sonView.layer.shadowColor = UIColor.black.cgColor
        sonView.layer.shadowRadius = 2
        sonView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
//        let newView = UIView()
//        newView.backgroundColor = fatherView.backgroundColor
//        newView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
//        
//        
//        // visual effects
//        newView.layer.shadowOpacity = 0.5
//        newView.layer.shadowColor = UIColor.blackColor().CGColor
//        newView.layer.shadowRadius = 3
//        newView.layer.shadowOffset = CGSizeMake(0, 3)
//        sonView.addSubview(newView)
        // shadow并不总是方形的，多根据内容区域的形状来决定，比如demo中的秃林
        //但是实时计算很耗费资源，特别是有多个子 alpha-masked 的layer
        //如果提前知道想要的投影的形状，可以通过食用shadowPath来提升性能,它是CGPathRef,

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var subViews = fatherView.subviews
        
        var subLayers = fatherView.layer.sublayers
        
        let subLayer = subLayers![0]
        let sonLayer = sonView.layer
        
        if subLayer == sonLayer {
            resultLabel.text?.append("\n")
            resultLabel.text?.append("RedView's layer's subLayer is\n \(subLayer)\n")
            resultLabel.text?.append("WhiteView's layer is\n \(sonLayer)\n")

            resultLabel.text?.append("They are the same\n")
        }
        
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
