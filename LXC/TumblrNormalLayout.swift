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
    
    //用户名宽度
    var blogNameWidth: CGFloat = 0
    
    //图片区域高度
    var imagesHeight: CGFloat = 0
    var imagesTop: CGFloat = 0
    
    
    var quetoHeight: CGFloat = 0

    //转发评论区域高度
    var reblogHeight: CGFloat = 0
    var reblogTop: CGFloat = 0
    var reblogAttributes: NSAttributedString?
    
    var imagesFrame: [CGRect] = []
        
    func fitPostData(tumblrPost: TumblrPost) {
        
        if post != tumblrPost{
            post = tumblrPost
            self.layout()
        }
    }
    
    func layout() {
        
        reset()
        
        guard let tumblrPost = post else {
            height = 0
            return
        }
        
        //头部高度
        nameTop = 0
        height += nameHeight
        blogNameWidth = LayoutManager.computeBlogNameWidth(tumblrPost.blogName)
        
        //图片高度
        imagesTop = nameHeight
        let computedHeight = LayoutManager.computeImagesHeight(tumblrPost.photos)
        imagesHeight = computedHeight.0
        imagesFrame = computedHeight.1
        
        height += imagesHeight
        
        //转发内容
        reblogTop = 0
        reblogTop += nameHeight
        reblogTop += imagesHeight
        
        if let safeReblog = tumblrPost.reblog, let comment = safeReblog.comment where !comment.isEmpty {
            let attributes = comment.convertToAttributedString()
            reblogAttributes = attributes
            reblogHeight = LayoutManager.computeRelogHeight(attributes) + 2 * kTMCellPadding
            
        } else {
            reblogHeight = 0
            
            //如果comment ＝ 0，看一下treeHtml
            if let safeReblog = tumblrPost.reblog, let treeHtml = safeReblog.treeHtml where !treeHtml.isEmpty {
                let attributes = treeHtml.convertToAttributedString()
                reblogAttributes = attributes
                reblogHeight = LayoutManager.computeRelogHeight(attributes) + 3 * kTMCellPadding
            }
            
        }
        
        height += reblogHeight
        
    }
    
    func reset() {
        
        nameTop = 0
        height = 0
        imagesTop = 0
        imagesHeight = 0
        imagesFrame = []
        reblogHeight = 0
        reblogTop = 0
        reblogAttributes = nil
        
    }
    
    

}














