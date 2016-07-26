//
//  Alamofire+SiwftyJSON.swift
//  LXC
//
//  Created by renren on 16/7/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

extension Request {
    
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, ErrorType?) -> Void) -> Self {
        return responseSwiftyJSON(nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, ErrorType?) -> Void) -> Self {
        
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (response) in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var responseJSON: JSON
                if response.result.isFailure
                {
                    responseJSON = JSON.null
                } else {
                    responseJSON = SwiftyJSON.JSON(response.result.value!)
                }
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request!, self.response, responseJSON, response.result.error)
                })
            })
            
        })
        
    }

}
