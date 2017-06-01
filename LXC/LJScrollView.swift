//
//  LJScrollview.swift
//  LXC
//
//  Created by dreamer on 2017/6/1.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJScrollViewProtocol: UIScrollViewDelegate {
    
    //默认是true，看是否需要子view一起滑动
    func scrollView(_ scrollView: LJScrollView, scrollWithSubView: UIScrollView) -> Bool
}

private var kMContext = 0

class LJScrollViewProtocolForward: NSObject, LJScrollViewProtocol {
    
    weak var delegate: LJScrollViewProtocol?
    
    func scrollView(_ scrollView: LJScrollView, scrollWithSubView: UIScrollView) -> Bool {
        return true
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        guard let d = self.delegate else {
            return responds(to: aSelector)
        }
        return d.responds(to: aSelector) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        guard let d = self.delegate else {
            return forwardingTarget(for: aSelector)
        }
        if d.responds(to: aSelector) {
            return d
        }
        return forwardingTarget(for: aSelector)
    }
    
}

class LJScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    public var scrollDelegate: LJScrollViewProtocol?
    fileprivate var forwarder: LJScrollViewProtocolForward?
    fileprivate var observedViews: [UIScrollView]?
    
    fileprivate var isObserving: Bool = false
    fileprivate var lock: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    func customInit() {
        self.forwarder = LJScrollViewProtocolForward()
        super.delegate = self.forwarder
    }
    
    
    
}













