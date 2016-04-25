//
//  ImageFilterView.swift
//  LXC
//
//  Created by renren on 16/3/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import GLKit
import OpenGLES

/**
 
    http://objccn.io/issue-16-4/
 
    http://www.2cto.com/kf/201312/262253.html
 
    http://site.douban.com/129642/widget/notes/5513129/note/268261078/
 
 
    https://developer.apple.com/downloads/index.action?name=Graphics
 
    https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
 
 
    https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_filer_recipes/ci_filter_recipes.html#//apple_ref/doc/uid/TP30001185-CH4-SW11
 
 
    core Image
    https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html#//apple_ref/doc/uid/TP30001185
 */

class ImageFilterView: GLKView {
    
    var ciContext : CIContext!
    
    var ciFilter : CIFilter! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var inputImage : UIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame, context: EAGLContext(API: .OpenGLES2))
        clipsToBounds = true
        ciContext = CIContext(EAGLContext: context)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        self.context = EAGLContext(API: .OpenGLES2)
        ciContext = CIContext(EAGLContext: context)
    }
    
    override func drawRect(rect: CGRect) {
        if ciContext != nil && inputImage != nil && ciFilter != nil {
            let inputCIImage = CIImage(image: inputImage)
            ciFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
            addAdditionalProperties()
            if let outputImage = ciFilter.outputImage {
                clearBackground()
                
                let inputBounds = inputCIImage!.extent
                let drawableBounds = CGRect(x: 0, y: 0, width: self.drawableWidth, height: self.drawableHeight)
                let targetBounds = imageBoundsForContentMode(inputBounds, toRect: drawableBounds)
                ciContext.drawImage(outputImage, inRect: targetBounds, fromRect: inputBounds)
            }
        }
    }
    
    func addAdditionalProperties() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        if ciFilter.name == "CIVignetteEffect" {
            let ciVector = CIVector(x: height, y: (height+width))
            ciFilter.setValue(ciVector, forKey: "inputCenter")
            ciFilter.setValue(0.8, forKey: kCIInputIntensityKey)
            ciFilter.setValue((width/2 + height), forKey: "inputRadius")
        }
    }
    
    func imageBoundsForContentMode(fromRect: CGRect, toRect: CGRect) -> CGRect {
        switch contentMode {
        case .ScaleAspectFill:
            return aspectFill(fromRect, toRect: toRect)
        case .ScaleAspectFit:
            return aspectFit(fromRect, toRect: toRect)
        default:
            return fromRect
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    func clearBackground() {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        glClearColor(GLfloat(r), GLfloat(g), GLfloat(b), GLfloat(a))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        backgroundColor = UIColor.whiteColor()
    }
    
    func aspectFill(fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        //因为是 w/h, 如果from大的话，证明 from的宽偏大，否则偏小
        //如果偏大
        //需要等比缩小
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        } else {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        }
        
        //integral 整形的
        //Expand `rect' to the smallest rect containing it with integral origin and size.
        
        //NSLog(@"%@",NSStringFromCGRect( CGRectIntegral(CGRectMake(0, 15.6, 16.1, 20.2))));
        //{0,15}，{17,21}
        return CGRectIntegral(fitRect)
    }
    
    func aspectFit(fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        } else {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        }
        
        return CGRectIntegral(fitRect)
    }


}










