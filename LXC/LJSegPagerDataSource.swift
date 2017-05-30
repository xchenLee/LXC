//
//  LJSegPagerDataSource.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJSegPagerDataSource {
    
    func pageCount(_ pager: LJSegPager) -> Int
    func pageView(_ pager: LJSegPager, atIndex: Int) -> UIView
    
    func title(_ pager: LJSegPager, atIndex: Int) -> String
    func attributedTitle(_ pager: LJSegPager, atIndex: Int) -> NSAttributedString
}
