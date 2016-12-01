//
//  RxDashboard.swift
//  LXC
//
//  Created by renren on 16/8/22.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class RxDashboard: UIViewController {
    
   /* var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    let items = Observable.just([
        "First item",
        "Second item",
        "Third item"
    ])
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = RxUI.buildTableView()
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.items
            .bindTo(tableView.rx_itemsWithCellIdentifier("cell", cellType: UITableViewCell.self)){
                (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
        
        tableView
            .rx_modelSelected(String)
            .subscribeNext{
                value in
            
            }
            .addDisposableTo(disposeBag)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/

}
