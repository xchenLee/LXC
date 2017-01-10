//
//  PostBoard.swift
//  LXC
//
//  Created by renren on 17/1/4.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit


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
    var postIconsRect: [CGRect]!
    
    
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
        let originX = (kScreenWidth - 2 * spacing + 3 * kPostIconWidth) / 2
        
        let postTitles:[String] = ["text", "video", "gif", "link", "image", "quote"]
        self.postIconsRect = []
        self.postIcons = []
        for index in 0..<5 {
            
            let postIcon = PostIcon(icon: "", tip: postTitles[index])
            postIcons.append(postIcon)
            self.addSubview(postIcon)
            
            let row = CGFloat(index / 3)
            let column = CGFloat(index % 3)
            
            let left = originX + column * (kPostIconWidth + spacing)
            let top = iconTop + row * (kPostIconHeight + spacing)
            
            let rect = CGRect(x: left, y: top, width: kPostIconWidth, height: kPostIconHeight)
            postIconsRect.append(rect)
        }
        
        
    }
    
    override func layoutSubviews() {
        for index in 0..<5 {
            
            let postIcon = self.postIcons[index]
            let rect = self.postIconsRect[index]
            postIcon.frame = rect
        }
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchSelf() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.2
        }, completion:{(finish) in
            self.removeFromSuperview()
        })
    }

}
