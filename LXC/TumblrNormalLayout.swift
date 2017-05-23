//
//  TumblrNormalLayout.swift
//  LXC
//
//  Created by renren on 16/8/1.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

enum VideoSource: String {
    case Youtube = "youtube"
    case Instagram = "instagram"
    case Tumblr = "tumblr"
}

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
    
    //文本区域高度
    var titleHeight: CGFloat = 0
    var titleTop: CGFloat = 0
    var tittleText: String = ""
    
    var textHeight: CGFloat = 0
    var textTop: CGFloat = 0
    var textAttributedString: NSAttributedString?
    
    //视频区域
    var videoHeight: CGFloat = 0
    var videoTop: CGFloat = 0
    var outerVideo: Bool = false
    
    var indicatorTop: CGFloat = 0
    var indicatorLeft: CGFloat = 0
    
    var sourceIconName: String = ""
    var sourceFlagTop: CGFloat = 0
    var sourceFlagLeft: CGFloat = 0
    
    
    //tags高度
    var tagsHeight: CGFloat = 0
    var tagsTop: CGFloat = 0
    var tagsAttributedString: NSAttributedString?
    //var tagsRanges: [NSRange] = []
    

    //转发评论区域高度
    var reblogHeight: CGFloat = 0
    var reblogTop: CGFloat = 0
    var reblogAttributes: NSAttributedString?
    
    //工具栏
    var toolbarTop: CGFloat = 0
    
    var imagesFrame: [CGRect] = []
    
    var deleted: Bool = false
        
    func fitPostData(_ tumblrPost: TumblrPost) {
        
        if self.post != tumblrPost {
            self.post = tumblrPost
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
        
        //文本区域计算
        readTypeTextEntry(tumblrPost)
        
        //视频区域
        readVideoEntry(tumblrPost)
        
        //图片区域
        readImageEntry(tumblrPost)
        
        //读取tag部分
        readTagsLayout(tumblrPost)
        
        //读取转发区域
        readReblogEntry(tumblrPost)
        
        toolbarTop = height
        height += kTMCellToolBarHeight
    }
    
    func readVideoEntry(_ tumblrPost: TumblrPost) {
    
        videoTop = nameHeight
        
        if tumblrPost.type.lowercased() == "video" {
            
            var originalWidth = CGFloat(tumblrPost.thumbnailWidth)
            var originalHeight = CGFloat(tumblrPost.thumbnailHeight)
            
            if originalWidth > 0 && originalHeight > 0 {
                
                let originalSize = CGSize(width: originalWidth, height: originalHeight)
                let scale = ToolBox.getScaleSize(originalSize, max: kTMCellPhotoMaxSize)
                originalWidth = scale.width
                originalHeight = scale.height
            }
            
            if originalWidth == 0 || originalHeight == 0 {
                originalWidth = kScreenWidth
                originalHeight = kScreenWidth * 9 / 16
            }
            
            
            videoHeight = originalHeight
            
            if !tumblrPost.videoType.isEmpty && tumblrPost.videoType != "tumblr" {
                
                switch tumblrPost.videoType.lowercased() {
                case VideoSource.Youtube.rawValue:
                    sourceIconName = "icon_video_youtube"
                    break
                case VideoSource.Instagram.rawValue:
                    sourceIconName = "icon_video_instagram"
                    break
                default: break
                }
                
                outerVideo = true
                sourceFlagLeft = (kScreenWidth - kTMCellVideoSourceFlagSize) / 2
                sourceFlagTop = (videoHeight - kTMCellVideoSourceFlagSize) / 2
            }

            
            height += videoHeight
        }
        
    }
    
    func readImageEntry(_ tumblrPost: TumblrPost) {
        
        //图片高度
        imagesTop = nameHeight
        let computedHeight = LayoutManager.computeImagesHeight(tumblrPost.photos)
        imagesHeight = computedHeight.0
        imagesFrame = computedHeight.1
        
        height += imagesHeight
    }
    
    func readTypeTextEntry(_ tumblrPost: TumblrPost) {
        
        titleTop = nameHeight
        
        let typeString = tumblrPost.type.lowercased()
        
        // quote 类型
        if typeString == "quote" && !tumblrPost.text.isEmpty {
            
            textTop = titleHeight + titleTop
            
            let attributedString = LayoutManager.getTextEntryTextAttributedString(tumblrPost.text)
            let height = attributedString.heightWithConstrainedWidth(kTMCellTextContentWidth) + kTMCellPadding
            textHeight = height
            textAttributedString = attributedString
            
        }

        // text 类型
        if typeString == "text" && !tumblrPost.body.isEmpty {
            
            if tumblrPost.body.contains("<img") && !tumblrPost.body.contains("width=") {
                self.height = 0
                self.deleted = true
            }
            
            if !tumblrPost.title.isEmpty {
                
                let titleH = tumblrPost.title.heightWithConstrainedWidth(kTMCellTextContentWidth, font: kTMCellTitleFont)
                tittleText = tumblrPost.title
                titleHeight = titleH
            }
            textTop = titleHeight + titleTop
            
            let attributedString = LayoutManager.getTextEntryTextAttributedString(tumblrPost.body)
            //多加了padding,因为会贴底
            let height = attributedString.heightWithConstrainedWidth(kTMCellTextContentWidth) + kTMCellPadding
            textHeight = height
            textAttributedString = attributedString
        }
        
        self.height += titleHeight
        self.height += textHeight
    }
    
    func readTagsLayout(_ tumblrPost: TumblrPost) {
        
        tagsTop += nameHeight
        tagsTop += titleHeight
        tagsTop += textHeight
        tagsTop += videoHeight
        tagsTop += imagesHeight
        
        let tags = tumblrPost.tags
        if tags.count == 0 {
            return
        }
        
        // orginal version

        //var tagsString: String = "tags: "
        //for tag in tags {
        //    tagsString += "#\(tag.value!)# "
        //}
        
        //let attributedString = LayoutManager.getTagsAttributedString(tagsString)
        //let attributedString = NSMutableAttributedString(string: tagsString)
        //let ranges = LayoutManager.getTagRanges(tagsString)
        //tagsRanges = ranges
        //tagsAttributedString = attributedString
        //tagsHeight = LayoutManager.computeTagsHeight(attributedString)
        
        tagsHeight = LayoutManager.computeTagPangelHeight(tags)
        height += tagsHeight
    }
    
    func readReblogEntry(_ tumblrPost: TumblrPost) {
        
        reblogTop = 0
        reblogTop += nameHeight
        reblogTop += titleHeight
        reblogTop += textHeight
        reblogTop += videoHeight
        reblogTop += imagesHeight
        reblogTop += tagsHeight
        
        let typeString = tumblrPost.type.lowercased()
        
        //text类型,treeHtml和内容一致,不再显示
        if typeString == "text" && !tumblrPost.body.isEmpty {
            height += reblogHeight
            return
        }
        
        if let safeReblog = tumblrPost.reblog, let comment = safeReblog.comment, !comment.isEmpty {
            
            let attributes = LayoutManager.getReblogEntryTextAttributedString(comment)
            reblogAttributes = attributes
            reblogHeight = LayoutManager.computeRelogHeight(attributes)
            
        } else {
            reblogHeight = 0
            
            //如果comment ＝ 0，看一下treeHtml
            if let safeReblog = tumblrPost.reblog, let treeHtml = safeReblog.treeHtml, !treeHtml.isEmpty {
                let attributes = LayoutManager.getReblogEntryTextAttributedString(treeHtml)
                reblogAttributes = attributes
                reblogHeight = LayoutManager.computeRelogHeight(attributes)
            }
            
        }
        
        height += reblogHeight
    }
    
    func reset() {
        
        nameTop = 0
        height = 0
        
        titleTop = 0
        titleHeight = 0
        textTop = 0
        textHeight = 0
        
        imagesTop = 0
        imagesHeight = 0
        imagesFrame = []
        
        videoHeight = 0
        videoTop = 0
        indicatorTop = 0
        indicatorLeft = 0
        
        sourceFlagLeft = 0
        sourceFlagTop = 0
        sourceIconName = ""
        
        tagsTop = 0
        tagsHeight = 0
        
        reblogHeight = 0
        reblogTop = 0
        reblogAttributes = nil
        
    }
    
    

}
