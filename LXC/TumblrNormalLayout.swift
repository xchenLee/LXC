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
    
    //头部区域高度
    var nameHeight: CGFloat = kTMCellAvatarAreaHeight
    var nameTop: CGFloat = 0
    //图片区域高度
    var imagesHeight: CGFloat = 0
    var imagesTop: CGFloat = 0
    //文本区域高度
    var textHeight: CGFloat = 0
    var quetoHeight: CGFloat = 0
    
    var imagesFrame: [CGRect] = []
    
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
        nameTop = 0
        height += nameHeight
        //图片高度
        imagesTop = nameHeight
        let computedHeight = LayoutManager.computeImagesHeight(tumblrPost.photos)
        imagesHeight = computedHeight.0
        imagesFrame = computedHeight.1
        
        height += imagesHeight
        
        
    }
    
    func reset() {
        nameTop = 0
        height = 0
        imagesTop = 0
        imagesHeight = 0
        imagesFrame = []
        
        
    }
    
    

}














