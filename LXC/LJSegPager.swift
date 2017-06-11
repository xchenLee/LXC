//
//  LJSegPager.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit


protocol LJSegPagerProtocol: NSObjectProtocol {
    
    func segPager(_ pager: LJSegPager, didSelectView: UIView)
    func segPager(_ pager: LJSegPager, didSelectViewWithTitle: String)
    func segPager(_ pager: LJSegPager, didSelectIndex: NSInteger)
    
    func segPager(_ pager: LJSegPager, willDisplayView: UIView, atIndex: NSInteger)
    func segPager(_ pager: LJSegPager, endDisplayView: UIView, atIndex: NSInteger)
    
    //头部条的高度
    func segPagerControlHeight(_ pager: LJSegPager) -> CGFloat
    
    func segPager(_ pager: LJSegPager, didScrollWithHeader: LJParallaxHeader)
    func segPager(_ pager: LJSegPager, didEndDragWithHeader: LJParallaxHeader)
    
    func pagerShouldScrollToTop(_ pager: LJSegPager) -> Bool
}

protocol LJSegPagerDataSource: NSObjectProtocol {
    
    func numberOfPages(_ inSegPager: LJSegPager) -> Int
    func viewForPageAtIndex(_ segPager: LJSegPager, index: Int) -> UIView
    
    func title(_ pager: LJSegPager, atIndex: Int) -> String
    
    /*func pageCount(_ pager: LJSegPager) -> Int
    func pageView(_ pager: LJSegPager, atIndex: Int) -> UIView
    
    func attributedTitle(_ pager: LJSegPager, atIndex: Int) -> NSAttributedString*/

}

protocol LJPageProtocol: NSObjectProtocol {
    
    func shouldScrollWithSubView(_ pager: LJSegPager, subView: UIView) -> Bool
}

class LJSegPager: UIView {

    
    open weak var delegate: LJSegPagerProtocol?
    open weak var dataSource: LJSegPagerDataSource?
    open fileprivate(set) var pageCount: Int = 0
    fileprivate var controlHeight: CGFloat = 0.0
    
    
    fileprivate lazy var contentView: LJScrollView = {
        
        let temp = LJScrollView()
        //temp.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        temp.scrollDelegate = self
        self.addSubview(temp)
        
        return temp
    }()
    
    open lazy fileprivate(set) var segControl: LJSegControl = {
        
        let titles = ["Posts", "Likes"]
        let control = LJSegControl(titles)
        control.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        self.contentView.addSubview(control)
        return control
    }()
    
    open lazy fileprivate(set) var paralaxHeader: LJParallaxHeader? = {
        return self.contentView.parallaxHeader
    }()
    
    open lazy fileprivate(set) var pagerView: LJPager = {
        let pager = LJPager()
        pager.pagerDelegate = self
        pager.pagerDataSource = self
        self.contentView.addSubview(pager)
        return pager
    }()

    open var headerBounces: Bool {
        
        get {
            return self.contentView.bounces
        }
        
        set {
            self.contentView.bounces = newValue
        }
    }
    
    // MARK: - 构造器
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
    }
    
    open func reloadData() {
        self.pageCount = self.dataSource!.numberOfPages(self)
        self.controlHeight = 44.0
        if self.delegate != nil {
            self.controlHeight = self.delegate!.segPagerControlHeight(self)
        }
        var titles = [String]()
        for index in 0..<self.pageCount {
            let title = self.dataSource!.title(self, atIndex: index)
            titles.append(title)
        }
        self.segControl.titles = titles
        self.pagerView.reloadData()
    }
    
    open func scrollToTop(animated: Bool) {
        self.contentView.setContentOffset(CGPoint(x: 0, y:  -self.contentView.parallaxHeader.defaultHeight), animated: animated)
    }
    
    open func pageControlValueChanged(_ control: LJSegControl) {
        self.pagerView.showPageAtIndex(self.segControl.selectedIndex, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.pageCount <= 0 {
            self.reloadData()
        }
        
        self.layoutContentView()
        self.layoutSegControl()
        self.layoutPager()
    }
    
    func layoutContentView() {
        self.contentView.frame = self.bounds
        self.contentView.contentSize = self.contentView.size
        self.contentView.isScrollEnabled = true
        self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.parallaxHeader.defaultHeight, 0, 0, 0)
    }
    
    func layoutSegControl() {
        //TODO insets
        var frame = self.bounds
        frame.origin.y = 0
        frame.size.height = self.controlHeight
        self.segControl.frame = frame
    }
    
    func layoutPager() {
        
        var frame = self.bounds
        frame.origin.y = self.controlHeight
        frame.size.height -= self.contentView.parallaxHeader.minimumHeight
        self.pagerView.frame = frame
    }

}


extension LJSegPager: LJScrollViewProtocol {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        if self.delegate != nil {
            return self.delegate!.pagerShouldScrollToTop(self)
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.contentView {
            self.delegate?.segPager(self, didScrollWithHeader: self.paralaxHeader!)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.contentView {
            self.delegate?.segPager(self, didEndDragWithHeader: self.paralaxHeader!)
        }
    }
    
    
    func scrollView(_ scrollView: LJScrollView, scrollWithSubView: UIScrollView) -> Bool {
        if  scrollWithSubView == self.pagerView {
            return false
        }
        
        guard let selectPage = self.pagerView.currentPage as? LJPageProtocol else {
            return true
        }
        
        return selectPage.shouldScrollWithSubView(self, subView: scrollWithSubView)
    }

}

extension LJSegPager: LJPagerProtocol {
    
    func pagerWillMove(_ pager: LJPager, toPage: UIView, index: Int) {
        self.segControl.select(index: index, animated: true)
    }
    
    func pagerDidMove(_ pager: LJPager,toPage: UIView, index: Int) {
        self.segControl.select(index: index, animated: false)
        self.changeToIndex(index)
    }
    
    func pagerWillDisplay(_ pager: LJPager, page: UIView, index: Int) {
        self.delegate?.segPager(self, willDisplayView: page, atIndex: index)
    }
    
    func pagerEndDisplay(_ pager: LJPager, page: UIView, index: Int) {
        self.delegate?.segPager(self, endDisplayView: page, atIndex: index)
    }
    
    func changeToIndex(_ index: Int) {
        
        self.delegate?.segPager(self, didSelectIndex: index)
        
        let title = self.segControl.titles?[index]
        self.delegate?.segPager(self, didSelectViewWithTitle: title!)
        
        let view = self.pagerView.currentPage
        self.delegate?.segPager(self, didSelectView: view!)
    }

}

extension LJSegPager: LJPagerDataSource {
    
    func numberOfPages(inPager: LJPager) -> Int {
        return self.pageCount
    }
    
    func viewForPager(pager: LJPager, atIndex: Int) -> UIView {
        return self.dataSource!.viewForPageAtIndex(self, index: atIndex)
    }
}

