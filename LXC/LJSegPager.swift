//
//  LJSegPager.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit


protocol LJSegPagerProtocol {
    
    func pager(_ pager: LJSegPager, didSelectView: UIView)
    func pager(_ pager: LJSegPager, didSelectViewWithTitle: String)
    func pager(_ pager: LJSegPager, didSelectIndex: NSInteger)
    
    func pager(_ pager: LJSegPager, willDisplayView: UIView, atIndex: NSInteger)
    func pager(_ pager: LJSegPager, endDisplayView: UIView, atIndex: NSInteger)
    
    func pagerSegControlHeight(_ pager: LJSegPager) -> CGFont
    
    func pager(_ pager: LJSegPager, didScrollWithHeader: LJParallaxHeader)
    func pager(_ pager: LJSegPager, didEndDragWithHeader: LJParallaxHeader)
    
    func pagerShouldScrollToTop(_ pager: LJSegPager) -> Bool
}

class LJSegPager: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
