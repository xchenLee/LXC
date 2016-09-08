//
//  Extensions.swift
//  LXC
//
//  Created by renren on 16/4/12.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

//import SwiftyDB
import UIKit
import MJRefresh
import Alamofire
import ObjectMapper



extension String {
    
    
    
    func convertToAttributedString(font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        
        guard let data = self.dataUsingEncoding(NSUnicodeStringEncoding) else {
            return NSMutableAttributedString(string: self)
        }
        
        do {
            let options = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSForegroundColorAttributeName: textColor]
            
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
            
        } catch {
            return NSMutableAttributedString(string: self)
        }
    }
    
    /**
     
     //http://www.itstrike.cn/Question/feb10296-892d-486f-aa6a-396141184ad7.html

     
     //            let range = NSMakeRange(0, attributedString.string.characters.count)
     //
     //            let mutableAS = NSMutableAttributedString(attributedString: attributedString)
     //            mutableAS.enumerateAttributesInRange(range, options: [.Reverse]) { (attribute, range, stop) in
     //
     //                if attribute.keys.contains(NSLinkAttributeName) {
     //                    mutableAS.addAttribute(NSUnderlineColorAttributeName, value: UIColor.redColor(), range: range)
     //                    mutableAS.addAttribute(NSUnderlineStyleAttributeName, value: String(NSUnderlineStyle.StyleThick), range: range)
     //                }
     //            }
     //
     
     */
    
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        
        let constrainedSize = CGSizeMake(CGFloat.max, height)
        
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attributes = [NSFontAttributeName : font]
        
        let boundingRect = self.boundingRectWithSize(constrainedSize, options: options, attributes: attributes, context: nil)
        
        return boundingRect.width
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constrainedSize = CGSizeMake(width, CGFloat.max)
        
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin
        let attributes = [NSFontAttributeName : font]
        
        let boundingRect = self.boundingRectWithSize(constrainedSize, options: options, attributes: attributes, context: nil)
        
        return boundingRect.height
    }
}

extension NSAttributedString {

    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        
        let constrainedSize = CGSize(width: width, height: CGFloat.max)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin

        let boundingRect = self.boundingRectWithSize(constrainedSize, options: options, context: nil)
        
        return ceil(boundingRect.height)
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        
        let constrainedSize = CGSize(width: CGFloat.max, height: height)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin

        let boundingRect = self.boundingRectWithSize(constrainedSize, options: options, context: nil)
        
        return ceil(boundingRect.width)
    }
}


extension UIColor {
    
    class func fromARGB(rgb : Int, alpha : Float) ->UIColor {
        let red   =  CGFloat(rgb & 0xFF0000 >> 16) / 255.0
        let green =  CGFloat(rgb & 0x00FF00 >>  8) / 255.0
        let blue  =  CGFloat(rgb & 0x0000FF >>  0) / 255.0
        let alph  =  CGFloat(alpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alph)
    }
    
}

extension UITableView {
    
    
    func addPullDownRefresh(handler:()->Void) {
        
        let header = MJRefreshNormalHeader.init(refreshingBlock: handler)
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.hidden = true
        self.mj_header = header
    }
    
    func addPullUp2LoadMore(handler:()->Void) {
        
        let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: handler)
        self.mj_footer = footer
    }
    
    func endRefreshing() {
        self.mj_header.endRefreshing()
    }
    
    func endLoadingMore() {
        self.mj_footer.endRefreshing()
    }
    
}


/**
 
 http://stackoverflow.com/questions/8915630/ios-uiimageview-how-to-handle-uiimage-image-orientation
 */

extension UIImage {
    
    func fixOrientationOne() ->UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func fixOrientation() -> UIImage {
        
        var transform = CGAffineTransformIdentity
        
        let width = self.size.width
        let height = self.size.height
        
        switch self.imageOrientation {
        case .Up:
            return self
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, width, height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        default:
            break
        }
        let contextRef = CGBitmapContextCreate(nil, Int(width), Int(height),
                                               CGImageGetBitsPerComponent(self.CGImage), 0,
                                               CGImageGetColorSpace(self.CGImage),
                                               CGImageGetBitmapInfo(self.CGImage).rawValue);
        CGContextConcatCTM(contextRef, transform)
        
        switch self.imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(contextRef, CGRectMake(0, 0, height, width), self.CGImage);
        default:
            CGContextDrawImage(contextRef, CGRectMake(0, 0, height, width), self.CGImage);
            break
        }
        
        let cgImg = CGBitmapContextCreateImage(contextRef)
        let image = UIImage(CGImage: cgImg!)
        
        return image
    }
}

extension Request {
    
    internal static func newError(code: Error.Code, failureReason: String) -> NSError {
        let errorDomain = "com.alamofireobjectmapper.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    public static func ObjectMapperSerializer<T: Mappable>(keyPath: String?, mapToObject object: T? = nil, context: MapContext? = nil) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            
            if let object = object {
                Mapper<T>().map(JSONToMap, toObject: object)
                return .Success(object)
            } else if let parsedObject = Mapper<T>(context: context).map(JSONToMap){
                return .Success(parsedObject)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter object:            An object to perform the mapping on to
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    
    public func responseObject<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.ObjectMapperSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
    }
    
    public static func ObjectMapperArraySerializer<T: Mappable>(keyPath: String?, context: MapContext? = nil) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = newError(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            
            if let parsedObject = Mapper<T>(context: context).mapArray(JSONToMap){
                return .Success(parsedObject)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    public func responseArray<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.ObjectMapperArraySerializer(keyPath, context: context), completionHandler: completionHandler)
    }
}

