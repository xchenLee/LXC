//
//  ScratchViewOne.swift
//  LXC
//
//  Created by renren on 16/5/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


struct Matrix {
    
    let rows : Int
    let columns : Int
    
    var grid : [Int]
    
    init(rows : Int, columns : Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: 0, count: rows * columns)
    }
    
    func indexIsValid(_ row : Int, column : Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row : Int, column : Int) -> Int {
        
        get {
            assert(indexIsValid(row, column: column))
            return grid[row * column + column]
        }
        
        set {
            assert(indexIsValid(row, column: column))
            grid[row * column + column] = newValue
        }
    }
    
    mutating func fillWithValue(_ value : Int) {
        self.grid = Array(repeating: value, count: rows * columns)
    }
    
}


protocol ScratchViewOneDelegate {
    //进度发生变化
    func scratchProgressChanged(_ scratchView : ScratchViewOne, maskingProgress : CGFloat)
}

let kDefaultRadius : Int = 30

class ScratchViewOne: UIImageView {
    
    fileprivate var radius : Int = 10
    fileprivate var tilesX : Int = 0
    fileprivate var tilesY : Int = 0
    fileprivate var tilesFilled : Int = 0
    
    fileprivate var colorSpace : CGColorSpace?
    fileprivate var imgContext : CGContext?
    
    fileprivate var touchPoints  : [CGPoint]?
    fileprivate var maskedMatrix : Matrix?
    
    override var image : UIImage? {
        didSet {
            radius = kDefaultRadius
            customInit()
        }
    }
    
    var delegate : ScratchViewOneDelegate?

    var maskingProgress     : CGFloat  {
        get {
            let filled = CGFloat(tilesFilled)
            let max = CGFloat((self.maskedMatrix?.columns)! * (self.maskedMatrix?.rows)!)
            return filled / max
        }
    }
    var scratchingDelegate  : ScratchViewOneDelegate?
    
    func fuck(_ image : UIImage, radius : Int) {
        self.image = image
        self.radius = radius
        self.customInit()
    }
    
    func customInit() {
        self.isUserInteractionEnabled = true
        
        if self.image == nil {
            tilesX = 0
            tilesY = 0
            maskedMatrix = nil
            if imgContext != nil {
                imgContext = nil
            }
            if colorSpace != nil {
                colorSpace = nil
            }
            return
        }
        
        touchPoints = []
        let w = (self.image?.size.width)! * (self.image?.scale)!
        let h = (self.image?.size.height)! * (self.image?.scale)!
        let size = CGSize(width: w, height: h)
        
        if colorSpace == nil {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        if imgContext != nil {
            imgContext = nil
        }
        imgContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: Int(size.width * 4), space: colorSpace!, bitmapInfo: 1)
        
        (imgContext)?.draw((self.image?.cgImage)!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let blendMode = CGBlendMode.clear
        (imgContext)?.setBlendMode(blendMode)
        
        tilesX = Int(size.width / CGFloat(2 * radius))
        tilesY = Int(size.height / CGFloat(2 * radius))
        
        self.maskedMatrix = Matrix(rows: tilesX, columns: tilesY)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.image = self.addTouches(touches as NSSet)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.image = self.addTouches(touches as NSSet)
    }
    
    func addTouches(_ set : NSSet) -> UIImage {
        let w = (self.image?.size.width)! * (self.image?.scale)!
        let h = (self.image?.size.height)! * (self.image?.scale)!
        let size = CGSize(width: w, height: h)
        
        (imgContext)?.setFillColor(UIColor.clear.cgColor)
        (imgContext)?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
        
        let tempFilled = tilesFilled
        
        for touch in set {
            
            (imgContext)?.beginPath()
            var touchPoint = (touch as AnyObject).location(in: self)
            touchPoint =  ToolBox.convertUIPointToQuartz(touchPoint, frameSize: self.bounds.size)
            touchPoint = ToolBox.scalePoint(touchPoint, previousSize: self.bounds.size, currentSize: size)
            
            if (touch as AnyObject).phase == UITouchPhase.began {
                
                self.touchPoints?.removeAll()
                self.touchPoints?.append(touchPoint)
                self.touchPoints?.append(touchPoint)
                
                let rect = CGRect(x: touchPoint.x - CGFloat(radius), y: touchPoint.y - CGFloat(radius), width: CGFloat(radius * 2), height: CGFloat(radius * 2))
                (imgContext)?.addEllipse(in: rect)
                imgContext?.fillPath()
                
                fillTileWithPoint(rect.origin)
            }
            else if ((touch as AnyObject).phase == UITouchPhase.moved) {
                
                self.touchPoints?.append(touchPoint)
                
                (imgContext)?.setStrokeColor(UIColor.yellow.cgColor.components!)
                (imgContext)?.setLineCap(.round)
                (imgContext)?.setLineWidth(CGFloat(2 * radius))
                
                while(self.touchPoints?.count > 3) {
                    var bezier = [CGPoint](repeating: CGPoint.zero, count: 4)
                    bezier[0] = self.touchPoints![1]
                    bezier[3] = self.touchPoints![2]
                    
                    let k : CGFloat = 0.3
                    let len = sqrt(pow(bezier[3].x - bezier[0].x, 2) + pow(bezier[3].y - bezier[0].y, 2))
                    bezier[1] = self.touchPoints![0]
                    bezier[1] = self.normalizeVector(CGPoint(x: bezier[0].x - bezier[1].x - (bezier[0].x - bezier[3].x), y: bezier[0].y - bezier[1].y - (bezier[0].y - bezier[3].y)))
                    bezier[1].x *= CGFloat(len) * k;
                    bezier[1].y *= len * k;
                    bezier[1].x += bezier[0].x;
                    bezier[1].y += bezier[0].y;
                    
                    bezier[2] = bezier[3]
                    bezier[2] = self.normalizeVector(CGPoint( x: (bezier[3].x - bezier[2].x)  - (bezier[3].x - bezier[0].x), y: (bezier[3].y - bezier[2].y)  - (bezier[3].y - bezier[0].y)))
                    bezier[2].x *= len * k;
                    bezier[2].y *= len * k;
                    bezier[2].x += bezier[3].x;
                    bezier[2].y += bezier[3].y;

                    (imgContext)?.move(to: CGPoint(x: bezier[0].x, y: bezier[0].y));
                    
                    let fromPoint = CGPoint(x: bezier[3].x, y: bezier[3].y)
                    let control1 = CGPoint(x: bezier[1].x, y: bezier[1].y)
                    let control2 = CGPoint(x: bezier[2].x, y: bezier[2].y)
                    
                    imgContext?.addCurve(to: fromPoint, control1: control1, control2: control2)
                    self.touchPoints?.remove(at: 0)
                }
                
                (imgContext)?.strokePath()
                
                var prevPoint = (touch as AnyObject).previousLocation(in: self)
                prevPoint = ToolBox.convertUIPointToQuartz(prevPoint, frameSize: self.bounds.size)
                prevPoint = ToolBox.scalePoint(prevPoint, previousSize: self.bounds.size, currentSize: size)
                fillTileWithTwoPoints(touchPoint, end: prevPoint)
            }
        }
        
        if tempFilled != tilesFilled {
            delegate?.scratchProgressChanged(self, maskingProgress: self.maskingProgress)
        }
        let cgImage = (imgContext)?.makeImage()
        let image = UIImage(cgImage: cgImage!)
        return image
    }
    
    func fillTileWithPoint(_ point : CGPoint) {
        var x : Int
        var y : Int
        let newX = max(min(point.x, (self.image?.size.width)! - 1), 0)
        let newY = max(min(point.y, (self.image?.size.height)! - 1), 0)
        
        x = Int(newX * CGFloat((self.maskedMatrix?.rows)!) / (self.image?.size.width)!)
        y = Int(newY * CGFloat((self.maskedMatrix?.columns)!) / (self.image?.size.height)!)

        let columns = maskedMatrix![x, y]
        if columns <= 0 {
            maskedMatrix![x,y] = 1
        }
    }
    
    func fillTileWithTwoPoints(_ begin : CGPoint, end : CGPoint) {
        
        var incrementerForx : CGFloat
        var incrementerFory : CGFloat
        
    
        /* incrementers - about size of a tile */
        incrementerForx = (begin.x < end.x ? 1 : -1) * self.image!.size.width / CGFloat(tilesX);
        incrementerFory = (begin.y < end.y ? 1 : -1) * self.image!.size.height / CGFloat(tilesY);
    
        // iterate on points between begin and end
        var i = begin;
        while(i.x <= max(begin.x, end.x) && i.y <= max(begin.y, end.y) && i.x >= min(begin.x, end.x) && i.y >= max(begin.y, end.y)){
            fillTileWithPoint(i)
            i.x += incrementerForx
            i.y += incrementerFory
        }
        fillTileWithPoint(end)
    }

    
    func normalizeVector(_ p : CGPoint) -> CGPoint{
        var p = p
        let len = sqrt(p.x*p.x + p.y*p.y);
        if(0 == len){return CGPoint(x: 0, y: 0);}
        p.x /= len;
        p.y /= len;
        return p;
    }

    
}


















