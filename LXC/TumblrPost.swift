//
//  TumblrPost.swift
//  LXC
//
//  Created by renren on 16/7/28.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


/// All property types except for List and RealmOptional must be declared as var. List and RealmOptional properties must be declared as non-let properties.


/// https://realm.io/docs/swift/latest/api/Classes/Object.html

struct Relog : Mappable {
    
    var comment : String?
    var treeHtml : String?
    
    init?(_ map: Map) {
        
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
    
    init?(_ map: Map) {
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
    
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        caption <- map["caption"]
        originalSize  <- map["original_size"]
        altSizes <- map["alt_sizes"]
    }

}

class TumblrPost: Object, Mappable {


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

    let tags                         = List<StringObject>()
    
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


    required convenience init?(_ map: Map) {
        self.init()
    }


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
        

        var tmpTags: [String]? = nil
        tmpTags <- map["tags"]
        tmpTags?.forEach({ (tagString) in
            
            let stringObject = StringObject()
            stringObject.value = tagString
            tags.append(stringObject)
        })
        
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



// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
