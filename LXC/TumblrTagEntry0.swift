//
//  TumblrTagEntry0.swift
//  LXC
//
//  Created by renren on 16/8/8.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrTagEntry0: UIView {
    
    var cell: TumblrNormalCell?

    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        

        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        
    }
    
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        guard let post = tumblrLayout.post else {
            return
        }
        
        let tagCount = post.tags.count
        if tagCount > 0 {
            
        }
    }


}
