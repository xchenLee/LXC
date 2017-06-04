//
//  LJPager.swift
//  LXC
//
//  Created by dreamer on 2017/6/2.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJPagerProtocol: UIScrollViewDelegate {
    
    func pagerWillMove(_ pager: LJPager, toPage: UIView, index: Int)
    func pagerDidMove(_ pager: LJPager,toPage: UIView, index: Int)
    func pagerWillDisplay(_ pager: LJPager, page: UIView, index: Int)
    func pagerDidDisplay(_ pager: LJPager, page: UIView, index: Int)
}

protocol LJPagerDataSource: NSObjectProtocol {
    
    func numberOfPages(inPager: LJPager) -> Int
    func viewForPager(pager: LJPager, atIndex: Int) -> UIView
}


fileprivate class LJPagerProtocolForwarder: NSObject, UIScrollViewDelegate {
    
    weak var pager: LJPager?
    weak var delegate: LJPagerProtocol?
    
    override func responds(to aSelector: Selector!) -> Bool {
        
        if self.pager != nil && self.pager!.responds(to: aSelector) {
            return true
        }
        
        if self.delegate != nil && self.delegate!.responds(to: aSelector) {
            return true
        }
        
        return super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        
        if self.pager != nil && self.pager!.responds(to: aSelector) {
            return self.pager
        }
        
        if self.delegate != nil && self.delegate!.responds(to: aSelector) {
            return self.delegate
        }
        return super.forwardingTarget(for: aSelector)
    }

}


/**
 * 对UIScrollView做了一层封装 使用更方便
 * 暂时不支持xib吧
 *
 */
class LJPager: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //好像不能重名
    weak open var pagerDelegate: LJPagerProtocol?
    weak open var pagerDataSource: LJPagerDataSource?
    
    open var loadedPages: [UIView] = []
    open var currentPage: UIView?
    open var currentPageIndex: Int = 0
    
    
    fileprivate var pages: [Int: UIView] = [:]
    fileprivate var registeration: [String: UIView] = [:]
    fileprivate var reuseQueue = [UIView]()

    open var gutterWidth: CGFloat = 0.0
    
    fileprivate var _index: Int = 0
    fileprivate var _count: Int = 0
    fileprivate var _forwarder: LJPagerProtocolForwarder?
    
    
    // MARK: - 构造器
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    private func customInit() {
        _forwarder = LJPagerProtocolForwarder()
        _forwarder!.pager = self
        
        super.delegate = _forwarder
        self.isPagingEnabled = true
        self.scrollsToTop = false
        
        self.isDirectionalLockEnabled = true
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = true
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        if _count <= 0 {
            self.reloadData()
        }
        
        var size = self.size
        size.width = size.width * CGFloat(_count)
        if size != self.contentSize {
            self.contentSize = size
            let x = self.width * CGFloat(_index)
            super.setContentOffset(CGPoint(x: x, y: 0), animated: false)
            
            var frame: CGRect = CGRectZero
            frame.size = self.size
            for (index, page) in self.pages {
                page.left = self.width * CGFloat(index)
                page.frame = frame
            }
        }
    }
    
    // MARK: - 数据变化，刷新页面
    open func reloadData() {
        
        for (_, page) in self.pages {
            page.removeFromSuperview()
        }
        self.pages.removeAll()
        
        _count = self.pagerDataSource!.numberOfPages(inPager: self)
        if _count > 0 {
            _index = min(_index, _count - 1)
            self.loadPage(index: _index)
            self.setNeedsLayout()
        }
    }
    
    open func pageOfIndex(_ index: Int) -> UIView? {
        
        if index >= 0 && index < self.pages.count {
            return pages[index]
        }
        return nil
    }
    
    open func showPageAtIndex(_ index: Int, animated: Bool) {
        if index >= 0 && index < _count && index != _index {
            let x = self.width * CGFloat(index)
            self.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
        }
    }
    
    open func registerClass(_ class: Any, reuseIdentifier: String) {
        self.registeration[reuseIdentifier] = Any
    }
    
    open func dequeueResuablePage(withIdentifier: String) -> UIView? {
        
        return nil
    }
    
    // MARK: - 私有方法
    private func willMoveTo(index: Int) {
        self.loadPage(index: index)
        
    }
    
    private func didMoveTo(index: Int) {
        
    }
    
    private func loadPage(index: Int) {
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.width
        
        _index = Int( offsetX / width)
        self.didMoveTo(index: _index)
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.width
        
        _index = Int( offsetX / width)
        self.willMoveTo(index: _index)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.didMoveTo(index: _index)
        
    }
    
    // MARK: - UIGestureRecognizerDelegate
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIPanGestureRecognizer {
            let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self)
            if fabs(velocity.x) < fabs(velocity.y) {
                return false
            }
        }
        return true
    }

}










