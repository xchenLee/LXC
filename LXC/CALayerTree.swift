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
    
    @IBAction func addLayer(sender: UIButton) {
        
        sender.enabled = false
        
        let newLayer = CALayer()
        newLayer.backgroundColor = fatherView.backgroundColor?.CGColor
        newLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        newLayer.position = sonView.center
        sonView.layer.addSublayer(newLayer)
        
        // visual effects
        sonView.layer.shadowOpacity = 1
        sonView.layer.shadowColor = UIColor.blackColor().CGColor
        sonView.layer.shadowRadius = 2
        sonView.layer.shadowOffset = CGSizeMake(0, -10)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var subViews = fatherView.subviews
        
        var subLayers = fatherView.layer.sublayers
        
        var subLayer = subLayers![0]
        var sonLayer = sonView.layer
        
        if subLayer == sonLayer {
            resultLabel.text?.appendContentsOf("\n")
            resultLabel.text?.appendContentsOf("RedView's layer's subLayer is\n \(subLayer)\n")
            resultLabel.text?.appendContentsOf("WhiteView's layer is\n \(sonLayer)\n")

            resultLabel.text?.appendContentsOf("They are the same\n")
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
