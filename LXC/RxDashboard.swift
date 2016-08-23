//
//  RxDashboard.swift
//  LXC
//
//  Created by renren on 16/8/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxDashboard: UIViewController, UITableViewDelegate {
    
    var tableView: UITableView!
    
    let items = Observable.just([
        "First item",
        "Second item",
        "Third item"
    ])
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = RxUI.buildTableView()
        
        items
            .bindTo(tableView.rx_itemsWithCellIdentifier("cell", cellType: UITableViewCell.self)){
                (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
