//
//  ScratchView.swift
//  LXC
//
//  Created by renren on 16/5/23.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class ScratchView: UIView {

    
    var previousPoint : CGPoint?
    var currentPoint  : CGPoint?
    var bonusImage    : CGImage?
    var scratchImage  : CGImage?
    var contextMask   : CGContext?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.isOpaque = false
    }
    
    func addMask(_ image : UIImage) {
        
        let w = self.bounds.width
        let h = self.bounds.height
        bonusImage = ToolBox.fitImageToSize(image, w: w, h: h).cgImage
        
        buildResources()
    }
    
    func addMaskView(_ mask : UIView) {
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        
        mask.layer.render(in: UIGraphicsGetCurrentContext()!)
        mask.layer.contentsScale = scale
        
        bonusImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        buildResources()
    }
    
    fileprivate func buildResources() {
        let scale = UIScreen.main.scale

        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let imageW = (bonusImage)?.width
        let imageH = (bonusImage)?.height
        
        let pixels = CFDataCreateMutable(nil, imageW! * imageH!)
        
        contextMask = CGContext(data: CFDataGetMutableBytePtr(pixels), width: imageW!, height: imageH! , bitsPerComponent: 8, bytesPerRow: imageW!, space: colorSpace, bitmapInfo: 0)
        let dataProvider = CGDataProvider(data: pixels!);
        
        (contextMask)?.setFillColor(UIColor.black.cgColor);
        (contextMask)?.fill(CGRect(x: 0, y: 0, width: self.frame.size.width * scale, height: self.frame.size.height * scale));
        
        
        (contextMask)?.setStrokeColor(UIColor.white.cgColor);
        (contextMask)?.setLineWidth(12);
        (contextMask)?.setLineCap(.round);
        
        let mask = CGImage(maskWidth: imageW!, height: imageH!, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: imageW!, provider: dataProvider!, decode: nil, shouldInterpolate: false);
        scratchImage = (bonusImage)?.masking(mask!);

    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let imageToDraw = UIImage(cgImage: self.scratchImage!)
        imageToDraw.draw(in: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height))
    }
    
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touchesForView = event?.touches(for: self)
        if let touch = touchesForView?.first {
            currentPoint = touch.location(in: self)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touchesForView = event?.touches(for: self)
        if let touch = touchesForView?.first {
            currentPoint = touch.location(in: self)
            previousPoint = touch.previousLocation(in: self)
            self.scratchView(previousPoint!, endPoint: currentPoint!)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touchesForView = event?.touches(for: self)
        if let touch = touchesForView?.first {
            previousPoint = touch.previousLocation(in: self)
            self.scratchView(previousPoint!, endPoint: currentPoint!)
        }
    }
    
    
    func scratchView(_ startPoint : CGPoint, endPoint : CGPoint) {
        
        let scale = UIScreen.main.scale
        
        (contextMask)?.move(to: CGPoint(x: startPoint.x * scale, y: (self.frame.size.height - startPoint.y) * scale));
        (contextMask)?.addLine(to: CGPoint(x: endPoint.x * scale, y: (self.frame.size.height - endPoint.y) * scale));
        (contextMask)?.strokePath()
        
        self.setNeedsDisplay()

    }

}
