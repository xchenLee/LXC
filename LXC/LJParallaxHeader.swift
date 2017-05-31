//
//  LJParallaxHeader.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJParallaxProtocol {
    
    func didScroll(_ header: LJParallaxHeader)
}


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
            self.superview?.addObserver(self.parent!, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
}

// MARK: - 类 LJParallaxHeader
class LJParallaxHeader: NSObject {
    
    // MARK: - 公开可配置属性
    
    // 代理
    public var delegate: LJParallaxProtocol?
    
    // 避免循环引用
    public weak var scrollView: UIScrollView? {
        
        didSet {
            if scrollView != oldValue {
                self.scrollViewReset()
            }
        }
    }
    
    // 头部大小，默认200
    public var defaultHeight: CGFloat = 200.0
    
    // 头部最小大小，navi+status 高度 64
    public var minimumHeight: CGFloat = 64.0 {
        didSet {
            self.layoutContentView()
        }
    }
    
    // 头部控件配置view
    public var header: UIView?
    
    // 头部滚动百分比
    public private(set) var progress: CGFloat = 0.0 {
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
    private lazy var contentView: LJPContentView = {
        
        let view = LJPContentView()
        view.parent = self
        view.clipsToBounds = true
        return view
    }()
    private var observing: Bool = false
    
    // MARK: - 构造器
    override init() {
        super.init()
    }
    
    // MARK: - 私有方法
    
    // MARK: - 重新布局
    func layoutContentView() {
        
    }
    
    func scrollViewReset() {
        
        
    }
    
}
