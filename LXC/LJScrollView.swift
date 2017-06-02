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
            return super.responds(to: aSelector)
        }
        return d.responds(to: aSelector) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        guard let d = self.delegate else {
            return super.forwardingTarget(for: aSelector)
        }
        if d.responds(to: aSelector) {
            return d
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let view = scrollView as! LJScrollView
        view.scrollViewDidEndDecelerating(view)
        
        if self.delegate!.responds(to: #selector(scrollViewDidEndDecelerating(_:))) {
            self.delegate!.scrollViewDidEndDecelerating!(view)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let view = scrollView as! LJScrollView
        view.scrollViewDidEndDragging(view, willDecelerate: decelerate)
        if self.delegate!.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:))) {
            self.delegate!.scrollViewDidEndDragging!(view, willDecelerate: decelerate)
        }
    }
    
}

class LJScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    public var scrollDelegate: LJScrollViewProtocol? {
        
        set {
            self.forwarder?.delegate = newValue
            super.delegate = nil
            super.delegate = self.forwarder
        }
        
        get {
            return self.forwarder?.delegate
        }
    }
    
    public private(set) var parallaxHeader = LJParallaxHeader()
    
    fileprivate var forwarder: LJScrollViewProtocolForward?
    fileprivate var observedViews: [UIScrollView] = []
    
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
        
        self.showsVerticalScrollIndicator = false
        self.isDirectionalLockEnabled = true
        self.bounces = true
        self.panGestureRecognizer.cancelsTouchesInView = false
        
        self.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: &kMContext)
        self.isObserving = true
        
        self.parallaxHeader.scrollView = self
    }
    
    func addObservedView(_ scrollView: UIScrollView) {
        if !self.observedViews.contains(scrollView) {
            self.observedViews.append(scrollView)
            self.addObserverToView(scrollView)
        }
    }
    
    func removeObservedViews() {
        for scrollView in self.observedViews {
            self.removeObserverFromView(scrollView)
        }
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" && context == &kMContext {
            
            let newV = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            let oldV = change?[NSKeyValueChangeKey.oldKey] as! CGPoint
            
            let diff = oldV.y - newV.y
            if diff == 0.0 || !self.isObserving {
                return
            }
            
            if object is LJScrollView && ((object as! LJScrollView) == self) {
                
                //Adjust self scroll offset when scroll down
                if (diff > 0 && self.lock) {
                    self.scrollView(self, setContentOffset: oldV)
                    
                } else if (self.contentOffset.y < -self.contentInset.top && !self.bounces) {
                    
                    self.scrollView(self, setContentOffset: CGPoint(x: self.contentOffset.x, y: -self.contentInset.top))
                    
                } else if (self.contentOffset.y > -self.parallaxHeader.minimumHeight) {
                    
                    self.scrollView(self, setContentOffset: CGPoint(x: self.contentOffset.x, y: -self.parallaxHeader.minimumHeight))
                }

            } else {
                //Adjust the observed scrollview's content offset
                
                let scrollView = object as! UIScrollView
                self.lock = (scrollView.contentOffset.y > -scrollView.contentInset.top);
                
                //Manage scroll up
                if (self.contentOffset.y < -self.parallaxHeader.minimumHeight && self.lock && diff < 0) {
                    self.scrollView(scrollView, setContentOffset: oldV)
                }
                //Disable bouncing when scroll down
                if (!self.lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces)) {
                    self.scrollView(scrollView, setContentOffset: CGPoint(x: scrollView.contentOffset.x, y: -scrollView.contentInset.top))
                }
                
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func addObserverToView(_ scrollView: UIScrollView) {
        
        self.lock = scrollView.contentOffset.y > -scrollView.contentInset.top
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: &kMContext)
    }
    
    func removeObserverFromView(_ scrollView: UIScrollView) {
        scrollView .removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func scrollView(_ scrollView: UIScrollView, setContentOffset contentOffset: CGPoint) {
        self.isObserving = false
        scrollView.contentOffset = contentOffset
        self.isObserving = true
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isObserving = false
        self.removeObservedViews()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.isObserving = false
            self.removeObservedViews()
        }
    }

    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if otherGestureRecognizer.view == self {
            return false
        }
        
        // 只接受pan gesture
        if !(gestureRecognizer is UIPanGestureRecognizer) {
            return false
        }
        
        // 禁止 水平滑动
        let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self)
        if fabs(velocity.x) > fabs(velocity.y) {
            return false
        }
        
        // 只考虑 scrollView
        if !(otherGestureRecognizer.view is UIScrollView) {
            return false
        }
        
        let scrollView = otherGestureRecognizer.view as! UIScrollView
        
        
        // tricky case: 
        if scrollView.superview is UITableView {
            return false
        }
        
        var shouldScroll = true
        if self.scrollDelegate != nil{
            shouldScroll = self.scrollDelegate!.scrollView(self, scrollWithSubView: scrollView)
        }
        
        if shouldScroll {
            self.addObservedView(scrollView)
        }
        
        return shouldScroll
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentOffset")
        self.removeObservedViews()
    }
    
    
}













