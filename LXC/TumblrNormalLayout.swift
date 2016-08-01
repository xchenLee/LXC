//
//  TumblrNormalLayout.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class TumblrNormalLayout: NSObject {
    
    var post: TumblrPost?
    var height: CGFloat = 0
    
    var imagesHeight: CGFloat = 0
    var textHeight: CGFloat = 0
    var quetoHeight: CGFloat = 0
    
    func fitPostData(tumblrPost: TumblrPost) {
        
        if post != tumblrPost{
            post = tumblrPost
            self.layout()
        }
    }
    
    func layout() {
        
        guard let tumblrPost = post else {
            height = 0
            return
        }
        
        //头部高度
        height += kTMCellAvatarAreaHeight
        //图片高度
        imagesHeight = LayoutManager.computeImagesHeight(tumblrPost.photos)
        height += imagesHeight
        
        
        
    }
    
    

}
