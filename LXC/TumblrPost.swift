//
//  TumblrPost.swift
//  LXC
//
//  Created by renren on 16/7/28.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


/// All property types except for List and RealmOptional must be declared as var. List and RealmOptional properties must be declared as non-let properties.


/// https://realm.io/docs/swift/latest/api/Classes/Object.html

struct Relog : Mappable {
    
    var comment : String?
    var treeHtml : String?
    
    init?(map: Map) {
        
    }
    
    init(json: JSON) {
        sjMap(json)
    }
    
    mutating func sjMap(_ json: JSON) {
        comment = json["comment"].stringValue
        treeHtml = json["treeHtml"].stringValue
    }
    
    mutating func mapping(map: Map) {
        comment     <- map["comment"]
        treeHtml  <- map["tree_html"]
    }
}

struct PhotoSize : Mappable {
    
    var url : String?
    var width : Int = 0
    var height : Int = 0
    
    init?(map: Map) {
    }
    
    init(json: JSON) {
        sjMap(json)
    }
    
    mutating func sjMap(_ json: JSON) {
        url = json["url"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
    }
    
    mutating func mapping(map: Map) {
        
        url <- map["url"]
        width     <- map["width"]
        height  <- map["height"]
    }
}

struct Photo : Mappable {
    
    var caption : String?
    var originalSize : PhotoSize?
    var altSizes : [PhotoSize]?
    
    
    init?(map: Map) {
        
    }
    
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
    
    mutating func mapping(map: Map) {
        caption <- map["caption"]
        originalSize  <- map["original_size"]
        altSizes <- map["alt_sizes"]
    }

}

class TumblrPost: NSObject, Mappable {


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


    required convenience init?(map: Map) {
        self.init()
    }
    
    
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


    //ObjectMapper 转换的方法，实现mappable，
    func mapping(map: Map) {

        slug <- map["slug"]
        blogName <- map["blog_name"]
        avatarUrl = kTumblrAPIUrl + "blog/" + blogName + ".tumblr.com/avatar/64"
        postId <- map["id"]
        url <- map["post_url"]

        type <- map["type"]
        timestamp <- map["timestamp"]
        date <- map["date"]
        format <- map["format"]
        
        state <- map["state"]
        followed <- map["followed"]
        reblogKey <- map["reblog_key"]
        
        sourceUrl <- map["source_url"]
        sourceTitle <- map["source_title"]
        
        title <- map["title"]
        body <- map["body"]
        text <- map["text"]
        
        // ObjectMapper 的方法，注释掉
//        var tmpTags: [String]? = nil
//        tmpTags <- map["tags"]
//        tmpTags?.forEach({ (tagString) in
//            
//            let stringObject = StringObject()
//            stringObject.value = tagString
//            tags.append(stringObject)
//        })
        
        reblog <- map["reblog"]
        likedStamp <- map["liked_timestamp"]
        photos <- map["photos"]
        liked <- map["liked"]
        
        summary <- map["summary"]
        shortUrl <- map["short_url"]
        noteCount <- map["note_count"]
        imagePermalink <- map["image_permalink"]
        
        permalinkUrl <- map["permalink_url"]
        
        videoUrl <- map["video_url"]
        videoType <- map["video_type"]
        thumbnailUrl <- map["thumbnail_url"]
        thumbnailWidth <- map["thumbnail_width"]
        thumbnailHeight <- map["thumbnail_height"]
    }


}
