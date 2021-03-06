//
//  LJParallaxHeader.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJParallaxProtocol: NSObjectProtocol {
    
    func didScroll(_ header: LJParallaxHeader)
}

private var kLJPContext = 0

// MARK: - 类 LJPContentView
class LJPContentView: UIView {
    
    weak var parent: LJParallaxHeader?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if self.superview is UIScrollView {
            self.superview?.removeObserver(self.parent!, forKeyPath: "contentOffset")
        }
    }
    
    override func didMoveToSuperview() {
        if self.superview is UIScrollView {
            self.superview?.addObserver(self.parent!, forKeyPath: "contentOffset", options: .new, context: &kLJPContext)
        }
    }
}

// MARK: - 类 LJParallaxHeader
class LJParallaxHeader: NSObject {
    
    // MARK: - 公开可配置属性
    
    // 代理
    open weak var delegate: LJParallaxProtocol?
    
    // 避免循环引用
    open weak var scrollView: UIScrollView? {
        
        didSet {
            if scrollView != oldValue {
                self.scrollViewSet()
            }
        }
    }
    
    // 头部大小，默认200
    open var defaultHeight: CGFloat = 0.0 {
        didSet {
            
            if oldValue != defaultHeight {
                self.adjustScrollView(topInset: self.scrollView!.contentInset.top - oldValue + defaultHeight)
                
                self.updateConstraints()
                self.layoutContentView()
            }
        }
    }
    
    // 头部最小大小，navi+status 高度 64
    open var minimumHeight: CGFloat = 64.0 {
        didSet {
            self.layoutContentView()
        }
    }
    
    // 头部控件配置view
    public var header: UIView? {
        didSet {
            self.updateConstraints()
        }
    }
    
    // 头部滚动百分比
    open private(set) var progress: CGFloat = 0.0 {
        //如果变化，才调用delegate
        didSet {
            if oldValue != progress {
                self.delegate?.didScroll(self)
            }
        }
    }
    
    // MARK: - 私有属性
    
    // 内容承载view
    //    private lazy var contentView: UIView = UIView()
    fileprivate lazy var contentView: LJPContentView = {
        
        let view = LJPContentView()
        view.parent = self
        view.clipsToBounds = true
        return view
    }()
    fileprivate var isObserving: Bool = false
    
    // MARK: - 构造器
    override init() {
        super.init()
    }
    
    // MARK: - 重新布局
    func layoutContentView() {
        let minimumH = min(self.minimumHeight, self.defaultHeight)
        let relativeYOffset = self.scrollView!.contentOffset.y + self.scrollView!.contentInset.top - self.defaultHeight
        
        let relativeH = -relativeYOffset
        
        let frame = CGRect(x: 0, y: relativeYOffset, width: self.scrollView!.width, height: max(relativeH, minimumH))
        
        self.contentView.frame = frame
        
        //let contentInsetTop = self.scrollView!.contentInset.top
        //let contentOffsetY = self.scrollView!.contentOffset.y
        
        let div = self.defaultHeight - self.minimumHeight
        self.progress = (self.contentView.height - self.minimumHeight) / (div > 0 ? div : self.defaultHeight)
    }
    
    func updateConstraints() {

        guard let view = self.header else {
            return
        }
        
        view.removeFromSuperview()
        self.contentView.addSubview(view)
        
        //TODO 没看懂 回头查一下
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v":view])
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v":view])
        self.contentView.addConstraints(constraintH)
        self.contentView.addConstraints(constraintV)
    }
    
    // MARK: - 当scrollView 被设置的时候会走这个方法
    func scrollViewSet() {
        
        //这里其实就是把scrollView的 contentInset给改了
        
        self.adjustScrollView(topInset: self.scrollView!.contentInset.top + self.defaultHeight)
        self.scrollView!.addSubview(self.contentView)
        self.layoutContentView()
        self.isObserving = true
    }
    
    func adjustScrollView(topInset: CGFloat) {
        
        var inset = self.scrollView!.contentInset
        var offset = self.scrollView!.contentOffset
        
        offset.y += inset.top - topInset
        self.scrollView!.contentOffset = offset
        inset.top = topInset
        
        self.scrollView!.contentInset = inset
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" && context == &kLJPContext && (self.contentView.superview != nil) {
            self.layoutContentView()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

