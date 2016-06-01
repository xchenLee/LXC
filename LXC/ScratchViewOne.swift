//
//  ScratchViewOne.swift
//  LXC
//
//  Created by renren on 16/5/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

struct Matrix {
    
    let rows : Int
    let columns : Int
    
    var grid : [Int]
    
    init(rows : Int, columns : Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(count: rows * columns, repeatedValue: 0)
    }
    
    func indexIsValid(row : Int, column : Int) -> Bool {
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
    
    mutating func fillWithValue(value : Int) {
        self.grid = Array(count: rows * columns, repeatedValue: value)
    }
    
}


protocol ScratchViewOneDelegate {
    //进度发生变化
    func scratchProgressChanged(scratchView : ScratchViewOne, maskingProgress : CGFloat)
}

let kDefaultRadius : Int = 30

class ScratchViewOne: UIImageView {
    
    private var radius : Int = 10
    private var tilesX : Int = 0
    private var tilesY : Int = 0
    private var tilesFilled : Int = 0
    
    private var colorSpace : CGColorSpaceRef?
    private var imgContext : CGContextRef?
    
    private var touchPoints  : [CGPoint]?
    private var maskedMatrix : Matrix?
    
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
    
    func fuck(image : UIImage, radius : Int) {
        self.image = image
        self.radius = radius
        self.customInit()
    }
    
    func customInit() {
        self.userInteractionEnabled = true
        
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
        let size = CGSizeMake(w, h)
        
        if colorSpace == nil {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        if imgContext != nil {
            imgContext = nil
        }
        imgContext = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, Int(size.width * 4), colorSpace, 1)
        
        CGContextDrawImage(imgContext, CGRectMake(0, 0, size.width, size.height), self.image?.CGImage)
        
        let blendMode = CGBlendMode.Clear
        CGContextSetBlendMode(imgContext, blendMode)
        
        tilesX = Int(size.width / CGFloat(2 * radius))
        tilesY = Int(size.height / CGFloat(2 * radius))
        
        self.maskedMatrix = Matrix(rows: tilesX, columns: tilesY)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.image = self.addTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.image = self.addTouches(touches)
    }
    
    func addTouches(set : NSSet) -> UIImage {
        let w = (self.image?.size.width)! * (self.image?.scale)!
        let h = (self.image?.size.height)! * (self.image?.scale)!
        let size = CGSizeMake(w, h)
        
        CGContextSetFillColorWithColor(imgContext, UIColor.clearColor().CGColor)
        CGContextSetStrokeColorWithColor(imgContext, UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor)
        
        let tempFilled = tilesFilled
        
        for touch in set {
            
            CGContextBeginPath(imgContext)
            var touchPoint = touch.locationInView(self)
            touchPoint =  ToolBox.convertUIPointToQuartz(touchPoint, frameSize: self.bounds.size)
            touchPoint = ToolBox.scalePoint(touchPoint, previousSize: self.bounds.size, currentSize: size)
            
            if touch.phase == UITouchPhase.Began {
                
                self.touchPoints?.removeAll()
                self.touchPoints?.append(touchPoint)
                self.touchPoints?.append(touchPoint)
                
                let rect = CGRectMake(touchPoint.x - CGFloat(radius), touchPoint.y - CGFloat(radius), CGFloat(radius * 2), CGFloat(radius * 2))
                CGContextAddEllipseInRect(imgContext, rect)
                CGContextFillPath(imgContext)
                
                fillTileWithPoint(rect.origin)
            }
            else if (touch.phase == UITouchPhase.Moved) {
                
                self.touchPoints?.append(touchPoint)
                
                CGContextSetStrokeColor(imgContext, CGColorGetComponents(UIColor.yellowColor().CGColor))
                CGContextSetLineCap(imgContext, .Round)
                CGContextSetLineWidth(imgContext, CGFloat(2 * radius))
                
                while(self.touchPoints?.count > 3) {
                    var bezier = [CGPoint](count: 4, repeatedValue: CGPointZero)
                    bezier[0] = self.touchPoints![1]
                    bezier[3] = self.touchPoints![2]
                    
                    let k : CGFloat = 0.3
                    let len = sqrt(pow(bezier[3].x - bezier[0].x, 2) + pow(bezier[3].y - bezier[0].y, 2))
                    bezier[1] = self.touchPoints![0]
                    bezier[1] = self.normalizeVector(CGPointMake(bezier[0].x - bezier[1].x - (bezier[0].x - bezier[3].x), bezier[0].y - bezier[1].y - (bezier[0].y - bezier[3].y)))
                    bezier[1].x *= CGFloat(len) * k;
                    bezier[1].y *= len * k;
                    bezier[1].x += bezier[0].x;
                    bezier[1].y += bezier[0].y;
                    
                    bezier[2] = bezier[3]
                    bezier[2] = self.normalizeVector(CGPointMake( (bezier[3].x - bezier[2].x)  - (bezier[3].x - bezier[0].x), (bezier[3].y - bezier[2].y)  - (bezier[3].y - bezier[0].y)))
                    bezier[2].x *= len * k;
                    bezier[2].y *= len * k;
                    bezier[2].x += bezier[3].x;
                    bezier[2].y += bezier[3].y;

                    CGContextMoveToPoint(imgContext, bezier[0].x, bezier[0].y);
                    CGContextAddCurveToPoint(imgContext, bezier[1].x, bezier[1].y, bezier[2].x, bezier[2].y, bezier[3].x, bezier[3].y);
                    self.touchPoints?.removeAtIndex(0)
                }
                
                CGContextStrokePath(imgContext)
                
                var prevPoint = touch.previousLocationInView(self)
                prevPoint = ToolBox.convertUIPointToQuartz(prevPoint, frameSize: self.bounds.size)
                prevPoint = ToolBox.scalePoint(prevPoint, previousSize: self.bounds.size, currentSize: size)
                fillTileWithTwoPoints(touchPoint, end: prevPoint)
            }
        }
        
        if tempFilled != tilesFilled {
            delegate?.scratchProgressChanged(self, maskingProgress: self.maskingProgress)
        }
        let cgImage = CGBitmapContextCreateImage(imgContext)
        let image = UIImage(CGImage: cgImage!)
        return image
    }
    
    func fillTileWithPoint(point : CGPoint) {
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
    
    func fillTileWithTwoPoints(begin : CGPoint, end : CGPoint) {
        
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

    
    func normalizeVector(var p : CGPoint) -> CGPoint{
        let len = sqrt(p.x*p.x + p.y*p.y);
        if(0 == len){return CGPointMake(0, 0);}
        p.x /= len;
        p.y /= len;
        return p;
    }

    
}


















