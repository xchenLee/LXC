//
//  TumblrPost.swift
//  LXC
//
//  Created by renren on 16/7/28.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import SwiftyJSON


/// All property types except for List and RealmOptional must be declared as var. List and RealmOptional properties must be declared as non-let properties.


/// https://realm.io/docs/swift/latest/api/Classes/Object.html

struct Relog {
    
    var comment : String?
    var treeHtml : String?
    
    init(json: JSON) {
        sjMap(json)
    }
    
    mutating func sjMap(_ json: JSON) {
        comment = json["comment"].stringValue
        treeHtml = json["treeHtml"].stringValue
    }
}

struct PhotoSize {
    
    var url : String?
    var width : Int = 0
    var height : Int = 0
    
    init(json: JSON) {
        sjMap(json)
    }
    
    mutating func sjMap(_ json: JSON) {
        url = json["url"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
    }
}

struct Photo {
    
    var caption : String?
    var originalSize : PhotoSize?
    var altSizes : [PhotoSize]?
    
    init(_ json: JSON) {
        sjMap(json)
    }
    
    mutating func sjMap(_ json: JSON) {
        caption = json["caption"].stringValue
        originalSize = PhotoSize(json: json["original_size"])
        
        let altJSON = json["alt_sizes"]
        altSizes = []
        if altJSON.type == .array {
            for objJSON in altJSON.arrayValue {
                let size = PhotoSize(json: objJSON)
                altSizes!.append(size)
            }
        }
    }

}

class TumblrPost: NSObject {


    var blogName : String    = ""

    var postId : Int           = 0
    var url : String         = ""

    var type : String        = ""
    var timestamp : Int    = 0
    var date : String        = ""
    var format : String      = ""
    var reblogKey : String   = ""

    var liked : Bool         = false
    var followed : Bool      = false
    var state : String       = ""



    var sourceUrl : String   = ""
    var sourceTitle : String = ""
    var totalPosts : Int32   = 0

    var tags          = [String]()
    
    var title: String = ""
    var body : String = ""
    var text : String   =  ""
    var slug : String  = ""
    
    var reblog : Relog?
    
    var likedStamp : Int64 = 0
    
    
    var imagePermalink : String = ""
    var photos : [Photo]?
    
    var shortUrl : String = ""
    var noteCount : Int = 0
    var summary : String = ""
    
    var avatarUrl : String = ""
    
    var videoUrl : String = ""
    var videoType : String = ""
    var thumbnailUrl : String = ""
    var thumbnailHeight : Int = 0
    var thumbnailWidth : Int = 0
    
    var permalinkUrl : String = ""
    
    //SwiftyJSON 转化成对象的方法
    func sjMap(_ json: JSON) {
        slug = json["slug"].stringValue
        blogName = json["blog_name"].stringValue
        avatarUrl = kTumblrAPIUrl + "blog/" + blogName + ".tumblr.com/avatar/64"
        postId = json["id"].intValue
        
        type = json["type"].stringValue
        timestamp = json["timestamp"].intValue
        date = json["date"].stringValue
        format = json["format"].stringValue
        
        state = json["state"].stringValue
        followed = json["followed"].boolValue
        reblogKey = json["reblog_key"].stringValue
        
        sourceUrl = json["source_url"].stringValue
        sourceTitle = json["source_title"].stringValue
        
        title = json["title"].stringValue
        body = json["body"].stringValue
        text = json["text"].stringValue
        
        
        tags = []
        
        let tagsJSON = json["tags"]
        if tagsJSON.type == .array {
            for objJSON in tagsJSON.arrayValue {
                tags.append(objJSON.stringValue)
            }
        }
        
        let reblogJSON = json["reblog"]
        reblog = Relog(json: reblogJSON)
        
        likedStamp = json["liked_timestamp"].int64Value
        
        photos = []
        let photosJSON = json["photos"]
        if photosJSON.type == .array {
            for objJSON in photosJSON.arrayValue {
                let photo = Photo(objJSON)
                photos?.append(photo)
            }
        }
        
        liked = json["liked"].boolValue
        
        summary = json["summary"].stringValue
        shortUrl = json["short_url"].stringValue
        noteCount = json["note_count"].intValue
        imagePermalink = json["image_permalink"].stringValue
        
        permalinkUrl = json["permalink_url"].stringValue
        
        videoUrl = json["video_url"].stringValue
        videoType = json["video_type"].stringValue
        thumbnailUrl = json["thumbnail_url"].stringValue
        thumbnailWidth = json["thumbnail_width"].intValue
        thumbnailHeight = json["thumbnail_height"].intValue

    }

}
