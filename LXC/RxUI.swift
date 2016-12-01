//
//  RxUI.swift
//  LXC
//
//  Created by renren on 16/8/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class RxUI: NSObject {
    
    class func buildTableView() -> UITableView {
        
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.rowHeight = 50
        return tableview
    }

}
