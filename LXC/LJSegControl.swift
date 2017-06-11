//
//  LJSegControl.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

typealias IndexChangeBlock = (_ index: Int) -> Void

enum LJSegControlType {
    case text
    case image
    case textImage
}

enum LJSegControlWidthType {
    case fixed
    case dynamic
}

class LJSegControl: UIControl {

    var titles: [String]?
    var images: [UIImage]?
    var imagesSelected: [UIImage]?
    
    var indexBlock: IndexChangeBlock?
    var type: LJSegControlType?
    var widthType: LJSegControlWidthType?
    var segBackgroundColor: UIColor?
    
    var indicatorHeight: CGFloat = 5.0
    var indicatorColor: UIColor?
    var segInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    var indicatorInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    var selectedIndex: Int = 0
    
    var titleTextAttr: [String: Any]?
    var titleTextAttrSelected: [String: Any]?
    
    override var frame: CGRect {
        didSet {
            self.updateRects()
        }
    }
    
    // MARK: - 私有属性
    private var scrollView: UIScrollView?
    private var indicatorLayer: CALayer?
    private var segWidth: CGFloat = 0.0
    private var segWidthArray: [CGFloat] = []
    
//    init() {
//        super.init()
//        self.commonInit()
//    }
    
    // MARK: - 初始化方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    init(_ titles: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.commonInit()
        self.titles = titles
        self.type = .text
        self.widthType = .fixed
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    init(images:[UIImage], imagesSelected: [UIImage]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.commonInit()
    }
    
    init(_ titles: [String], images:[UIImage], imagesSelected: [UIImage]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.commonInit()
    }
    
    func commonInit() {
        
        self.scrollView = LJHScrollView()
        self.scrollView?.bounces = false
        self.scrollView?.scrollsToTop = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView!)
        
        self.segBackgroundColor = UIColor.white
        self.indicatorColor = UIColor.red
        self.selectedIndex = 0
        
        self.type = .text
        
        self.indicatorLayer = CALayer()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.segWidth = 0.0
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            return
        }
        
        if (self.titles != nil) || (self.images != nil) {
            self.updateRects();
        }
    }
    
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateRects()
    }
    
    // MARK: - 对子控件进行布局
    func updateRects() {
        let width = self.width
        self.scrollView?.frame = CGRect(x: 0, y: 0, width: width, height: self.height)
        if self.sectionCount() > 0 {
            self.segWidth = self.width / CGFloat(self.sectionCount())
        }
        
        if self.type == .text {
            
            for (index, _) in self.titles!.enumerated() {
                let size = self.measture(titleAtIndex: index)
                let width = size.width + segInsets.left + segInsets.right
                if self.widthType == .fixed {
                    self.segWidth = max(width, segWidth)
                } else {
                    self.segWidthArray.append(width)
                }
            }
        }
        //TODO frame
        self.scrollView?.contentSize = CGSize(width: self.contentWidth(), height: self.height)
    }
    
    func indicatorFrame() -> CGRect {
        let top = self.height - self.indicatorHeight
        var segWidth: CGFloat = 0
        if self.type == .text {
            segWidth = self.measture(titleAtIndex: self.selectedIndex).width
            
            let xDelta: CGFloat = self.indicatorInsets.left
            let wDelta: CGFloat = self.indicatorInsets.right + self.indicatorInsets.left
            if widthType == .fixed {
                //TODO insets
                let left = self.segWidth * CGFloat(self.selectedIndex) + xDelta
                return CGRect(x: left, y: top, width: self.segWidth - wDelta, height: self.indicatorHeight)
            } else {
                let left = self.widthSum(poPosition: self.selectedIndex + 1)
                let width = self.segWidthArray[self.selectedIndex]
                return CGRect(x: left + xDelta, y: top, width: width - wDelta, height: self.indicatorHeight)
            }
            
        }
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }

    
    // MARK: - 选中到某个tab
    func select(index: Int, animated: Bool) {
        self.select(index: index, animated: animated, notify: false)
    }
    
    // MARK: - 工具方法
    func sectionCount() -> Int{
        if self.type == .text {
            return self.titles!.count
        } else if self.type == .image || self.type == .textImage {
            return self.images!.count
        }
        return 0
    }
    
    func contentWidth() -> CGFloat {
        if self.type == .text && self.widthType == .fixed{
            return CGFloat(self.titles!.count) * self.segWidth
        }
        if self.type == .text && self.widthType == .dynamic {
            return self.segWidthArray.reduce(0.0){$0 + $1}
        }
        return CGFloat(self.images!.count) * self.segWidth
    }
    
    func measture(titleAtIndex index: Int) -> CGSize {
        
        guard let titles = self.titles else {
            return CGSize(width: 0.0, height: 0.0)
        }
        if index >= titles.count {
            return CGSize(width: 0.0, height: 0.0)
        }
        
        let title = titles[index]
        let selected = index == self.selectedIndex
        let att = selected ? self.titleAttributesSelectedResult() : self.titleAttributesResult()
        return title.size(withAttri: att)
    }
    
    // MARK: - 如果有自定义文本属性装配上
    func titleAttributesResult() -> [String: Any] {
        var att: [String: Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        if self.titleTextAttr != nil {
            att.merge(dictionary: self.titleTextAttr!)
        }
        return att
    }
    
    func titleAttributesSelectedResult() -> [String: Any] {
        
        var att: [String: Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        if self.titleTextAttrSelected != nil {
            att.merge(dictionary: self.titleTextAttrSelected!)
        }
        return att
    }
    
    func attributedString(_ index: Int) -> NSAttributedString {
        let title = self.titles![index]
        let selected = index == self.selectedIndex
        let att = selected ? self.titleAttributesSelectedResult() : self.titleAttributesResult()
        return NSAttributedString(string: title, attributes: att)
    }
    
    func widthSum(poPosition positon: Int) -> CGFloat {
        return self.segWidthArray.sub(position: positon).reduce(0.0){$0 + $1}
    }
    
    // MARK: - 绘制
    override func draw(_ rect: CGRect) {
        self.segBackgroundColor!.setFill()
        UIRectFill(self.bounds)
        
        self.indicatorLayer?.backgroundColor = self.indicatorColor!.cgColor
        self.scrollView!.layer.sublayers = nil
        
        if self.type == .text {
            
            for (index, _) in self.titles!.enumerated() {
                let size = self.measture(titleAtIndex: index)
                let titleW = size.width
                let titleH = size.height
                var rect: CGRect
                //var fullRect: CGRect
                let top = (self.height - titleH) / 2 - self.indicatorHeight / 2
                
                if self.widthType == .fixed {
                    rect = CGRect(x: CGFloat(index) * self.segWidth + (self.segWidth - titleW) / 2, y: top, width: titleW, height: titleH)
                    //fullRect = CGRect(x: CGFloat(index) * self.segWidth, y: 0, width: self.segWidth, height: self.height)
                } else {
                    let left = self.widthSum(poPosition: index + 1)
                    let width = self.segWidthArray[index]
                    rect = CGRect(x: left, y: top, width: width, height: titleH)
                    //fullRect = CGRect(x: left, y: 0, width: width, height: self.height)
                }
                
                //rect = CGRect(x: CGFloat(ceilf(Float(rect.origin.x))), y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
                
                let textLayer = CATextLayer()
                textLayer.frame = rect
                textLayer.alignmentMode = kCAAlignmentCenter
                textLayer.string = self.attributedString(index)
                textLayer.contentsScale = UIScreen.main.scale
                self.scrollView?.layer.addSublayer(textLayer)
                
            }
            
        }
        
        if self.indicatorLayer!.superlayer == nil {
            self.indicatorLayer!.frame = self.indicatorFrame()
            self.scrollView?.layer.addSublayer(self.indicatorLayer!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: self)
        
        //TODO enlarge
        
        if self.bounds.contains(position) {
            var touchSeg: Int = 0
            if self.widthType == .fixed {
                touchSeg = Int((position.x + self.scrollView!.contentOffset.x) / self.segWidth)
            } else {
                var left = position.x + self.scrollView!.contentOffset.x
                for width in self.segWidthArray {
                    left = left - width
                    if left <= 0 {
                        break
                    }
                    touchSeg += 1
                }
            }
            
            var sectionsCount = 0
            if self.type == .text {
                sectionsCount = self.titles!.count
            }
            if self.selectedIndex != touchSeg && touchSeg < sectionsCount {
                //TODO
                self.select(index: touchSeg, animated: true, notify: true)
            }
            
        }
        
    }
    
    func select(index: Int, animated: Bool, notify: Bool) {
        
        self.selectedIndex = index
        self.setNeedsDisplay()
        self.scrollToSelectedSeg(animated: animated)
        
        if animated {
            if self.indicatorLayer?.superlayer == nil {
                self.scrollView!.layer.addSublayer(self.indicatorLayer!)
                self.select(index: index, animated: false, notify: true)
                return
            }
            
            if notify {
                self.notify(changeToIndex: index)
            }
            
            self.indicatorLayer?.actions = nil
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            self.indicatorLayer?.frame = self.indicatorFrame()
            CATransaction.commit()
        } else {
            
            self.indicatorLayer?.actions = [
                "position": NSNull.init(),
                "bounds": NSNull.init()
            ]
            self.indicatorLayer?.frame = self.indicatorFrame()
            if notify {
                self.notify(changeToIndex: index)
            }
        }
        
    }
    
    func notify(changeToIndex index: Int) {
        if self.superview != nil {
            self.sendActions(for: .valueChanged)
        }
        if self.indexBlock != nil {
            self.indexBlock!(index)
        }
    }
    
    func scrollToSelectedSeg(animated: Bool) {
        
        var newRect: CGRect
        var newOffset: CGFloat = 0
        
        if widthType == .fixed {
            
            newRect = CGRect(x: self.segWidth * CGFloat(self.selectedIndex), y: 0, width: self.segWidth, height: self.height)
            
            newOffset = (self.width - self.segWidth) / 2
        } else {
            
            let x = self.widthSum(poPosition: self.selectedIndex + 1)
            
            newRect = CGRect(x: x, y: 0, width: self.segWidthArray[self.selectedIndex], height: self.height)
            
            newOffset = (self.width - self.segWidthArray[self.selectedIndex]) / 2
        }
        
        newRect.origin.x -= newOffset
        newRect.size.width += newOffset * 2
        self.scrollView!.scrollRectToVisible(newRect, animated: animated)
    }

}















