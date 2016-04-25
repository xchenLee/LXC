//
//  UIImage+Orientation.swift
//  LXC
//
//  Created by renren on 16/3/21.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

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













