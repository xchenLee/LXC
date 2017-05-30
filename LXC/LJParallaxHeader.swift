//
//  LJParallaxHeader.swift
//  LXC
//
//  Created by dreamer on 2017/5/30.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

protocol LJParallaxProtocol {
    
    func parallaxHeaderDidScroll(_ header: LJParallaxHeader)
}

class LJParallaxHeader {

    open var content: UIView?
    open var header: UIView?
    
    open var delegate: LJParallaxProtocol?
    open var dataSource: LJSegPagerDataSource?
    
    open var defaultHeight: CGFloat?
    open var minimumHeight: CGFloat?
}
