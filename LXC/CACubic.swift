//
//  CACubic.swift
//  LXC
//
//  Created by renren on 16/5/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit


class CACubic: UIViewController {
    
    var container = UIView()
    
    
    lazy var faceArray : [UILabel] = {
        
        var faces : [UILabel] = []
        
        for i in 1...6 {
            let view = UILabel()
            view.backgroundColor = ToolBox.randomColor()
            view.text = "\(i)"
            view.textColor = UIColor.whiteColor()
            view.font = UIFont.systemFontOfSize(36, weight: UIFontWeightBold)
            view.textAlignment = .Center
            faces.append(view)
        }
        return faces
    
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerSize = (kScreenWidth - 80) / 2.0
        
        container.frame = CGRect(x: 0, y: 0, width: containerSize, height: containerSize)
        container.center = self.view.center
        
        self.view.addSubview(container)
        
        var transform : CATransform3D = CATransform3DIdentity

        transform.m34 = -1 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(-M_PI / 4), 1, 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(-M_PI / 4), 0, 1, 0);
        container.layer.sublayerTransform = transform
        
        let translation = containerSize / 2
        
        let one = faceArray[0]
        transform = CATransform3DMakeTranslation(0, 0, translation)
        addFace(one, transform: transform)
        
        let two = faceArray[1]
        transform = CATransform3DMakeTranslation(translation, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI / 2), 0, 1, 0)
        addFace(two, transform: transform)
        
        let three = faceArray[2]
        transform = CATransform3DMakeTranslation(0, -translation, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI / 2), 1, 0, 0)
        addFace(three, transform: transform)
        
        let four = faceArray[3]
        transform = CATransform3DMakeTranslation(0, translation, 0)
        transform = CATransform3DRotate(transform, CGFloat(-M_PI / 2), 1, 0, 0)
        addFace(four, transform: transform)
        
        let five = faceArray[4];
        transform = CATransform3DMakeTranslation(-translation, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(-M_PI / 2), 0, 1, 0);
        addFace(five, transform: transform)
        
        let six = faceArray[5]
        transform = CATransform3DMakeTranslation(0, 0, -translation)
        addFace(six, transform: transform)
        
    }
    
    func addFace(face : UIView, transform : CATransform3D) {
        
        face.frame = container.bounds
        face.center = CGPointMake(container.bounds.size.width / 2.0, container.bounds.size.height / 2.0)
        container.addSubview(face)
        
        face.layer.transform = transform
    }
    

}



















