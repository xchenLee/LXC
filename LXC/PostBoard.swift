//
//  PostBoard.swift
//  LXC
//
//  Created by renren on 17/1/4.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit
import pop


let kPostIconWidth: CGFloat = 80
let kPostIconHeight: CGFloat = 100


class PostIcon: UIControl {
    
    var icon: UIImageView!
    var text: UILabel!
    
    init(icon: String, tip: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: kPostIconWidth, height: kPostIconHeight))
        
        self.icon = UIImageView()
        self.icon.size = CGSize(width: kPostIconWidth, height: kPostIconWidth)
        self.icon.image = UIImage(named: icon)
        self.addSubview(self.icon)
        
        self.text = UILabel()
        self.text.text = tip
        self.text.textColor = UIColor.white
        self.text.textAlignment = .center
        
        self.backgroundColor = UIColor.red
        self.addSubview(self.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.icon.origin = CGPoint(x: 0, y: 0)
        self.text.origin = CGPoint(x: 0, y: kPostIconHeight - kPostIconWidth)
    }
}

class PostBoard: UIControl {
    
    var blurEffectView: UIVisualEffectView!
    
    var postIcons: [PostIcon]!
    var postIconsFinalRect: [CGRect]!
    
    var postIconsDelays: [TimeInterval] = [
        0.1, 0.15, 0.2,
        0.15, 0.2, 0.25
    ]
    
    
    // MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.fromARGB(0x000000, alpha: 0.7)
        self.addTarget(self, action: #selector(touchSelf), for: .touchUpInside)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView.isUserInteractionEnabled = false
        self.blurEffectView.frame = self.bounds
        
        self.addSubview(self.blurEffectView)
        
        let spacing: CGFloat = 30
        let iconTop = kScreenHeight / 2 - kPostIconHeight - spacing / 2
        let originX = (kScreenWidth - 2 * spacing - 3 * kPostIconWidth) / 2
        
        let postTitles:[String] = ["text", "video", "gif", "link", "image", "quote"]
        self.postIconsFinalRect = []
        self.postIcons = []
        for index in 0...5 {
            
            let postIcon = PostIcon(icon: "", tip: postTitles[index])
            postIcons.append(postIcon)
            self.addSubview(postIcon)
            
            let row = CGFloat(index / 3)
            let column = CGFloat(index % 3)
            
            let left = originX + column * (kPostIconWidth + spacing)
            let top = iconTop + row * (kPostIconHeight + spacing)
            
            let rect = CGRect(x: left, y: top, width: kPostIconWidth, height: kPostIconHeight)
            postIconsFinalRect.append(rect)
            
            
            postIcon.frame = rect
            postIcon.top = postIcon.top + (kScreenHeight - iconTop)
        }
        iconsAppearing()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        /*for index in 0...5 {
         
         let postIcon = self.postIcons[index]
         let rect = self.postIconsFinalRect[index]
         postIcon.frame = rect
         }*/
    }
    
    func iconsAppearing() {
        
        for index in 0...5 {
            let icon = postIcons[index]
            let animation = appearAnimation(index)
            
            icon.pop_add(animation, forKey: kPOPViewFrame)
        }
    }
    
    // MARK: animations
    func appearAnimation(_ index: Int) -> POPSpringAnimation{
        
        let finalFrame = postIconsFinalRect[index]
        let delay = postIconsDelays[index]
        
        let springAnimation = POPSpringAnimation()
        springAnimation.property = POPAnimatableProperty.property(withName: kPOPViewFrame) as! POPAnimatableProperty!
        springAnimation.springBounciness = 8
        springAnimation.springSpeed = 14
        springAnimation.beginTime = CACurrentMediaTime() + delay
        springAnimation.toValue = NSValue(cgRect: finalFrame)
        
        return springAnimation
    }
    
    func doDisappearAnimation() {
        
    }
    
    func touchSelf() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.2
        }, completion:{[unowned self](finish) in
            self.removeFromSuperview()
        })
    }

}
