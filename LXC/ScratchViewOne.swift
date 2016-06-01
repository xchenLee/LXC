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

class ScratchViewOne: UIImageView {
    
    private var radius : Int = 10
    private var tilesX : Int = 0
    private var tilesY : Int = 0
    private var tilesFilled : Int = 0
    
    private var colorSpace : CGColorSpaceRef?
    private var imgContext : CGContextRef?
    
    private var touchPoints  : [CGPoint]?
    private var maskedMatrix : Matrix?
    

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
        
        
    }
    
//    func addTouches(set : NSSet) -> UIImage {
//        let w = (self.image?.size.width)! * (self.image?.scale)!
//        let h = (self.image?.size.height)! * (self.image?.scale)!
//        let size = CGSizeMake(w, h)
//        
//        
//        
//        return nil
//    }
    
}


















