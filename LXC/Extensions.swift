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


extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
}


extension String {
    
    
    //通过location length 构建 String的range
    func range(_ location: Int, length: Int) -> Range<String.Index> {
        
        let sIndex = self.index(self.startIndex, offsetBy: location)
        let eIndex = self.index(sIndex, offsetBy: length)
        let rRange = sIndex..<eIndex
        return rRange
    }
    
    //通过location length 获取 String的 subString
    func subString(_ location: Int, length: Int) -> String? {
        
        let rRange = self.range(location, length: length)
        return substring(with: rRange)
    }
    
    //通过属性计算字符串大小
    func size(withAttri attributes: [String: Any]) -> CGSize {
        let nsString = self as NSString
        let size = nsString.size(attributes: attributes)
        return size
    }
    
    
    func convertToAttributedString(_ font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        
        guard let data = self.data(using: String.Encoding.unicode) else {
            return NSMutableAttributedString(string: self)
        }
        
        do {
            let options: [String : Any] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                //, NSForegroundColorAttributeName: textColor]
            
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
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSFontAttributeName : font]
        
        let boundingRect = self.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        
        return boundingRect.width
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSFontAttributeName : font]
        
        let boundingRect = self.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        
        return boundingRect.height
    }
}

extension NSAttributedString {

    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        
        let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin

        let boundingRect = self.boundingRect(with: constrainedSize, options: options, context: nil)
        
        return ceil(boundingRect.height)
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        
        let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin

        let boundingRect = self.boundingRect(with: constrainedSize, options: options, context: nil)
        
        return ceil(boundingRect.width)
    }
}


extension UIColor {
    
    class func fromARGB(_ rgb : Int, alpha : Float) ->UIColor {
        let red   =  CGFloat(rgb & 0xFF0000 >> 16) / 255.0
        let green =  CGFloat(rgb & 0x00FF00 >>  8) / 255.0
        let blue  =  CGFloat(rgb & 0x0000FF >>  0) / 255.0
        let alph  =  CGFloat(alpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alph)
    }
    
}

extension UITableView {
    
    
    func addPullDownRefresh(_ handler:@escaping ()->Void) {
        
        let header = MJRefreshNormalHeader.init(refreshingBlock: handler)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        self.mj_header = header
    }
    
    func addPullUp2LoadMore(_ handler:@escaping ()->Void) {
        
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
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return normalizedImage!;
    }
    
    func fixOrientation() -> UIImage {
        
        var transform = CGAffineTransform.identity
        
        let width = self.size.width
        let height = self.size.height
        
        switch self.imageOrientation {
        case .up:
            return self
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        default:
            break
        }
        let contextRef = CGContext(data: nil, width: Int(width), height: Int(height),
                                               bitsPerComponent: ((self.cgImage)?.bitsPerComponent)!, bytesPerRow: 0,
                                               space: ((self.cgImage)?.colorSpace!)!,
                                               bitmapInfo: ((self.cgImage)?.bitmapInfo.rawValue)!);
        contextRef?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            contextRef?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: height, height: width));
        default:
            contextRef?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: height, height: width));
            break
        }
        
        let cgImg = contextRef?.makeImage()
        let image = UIImage(cgImage: cgImg!)
        
        return image
    }
}








