//
//  NavBarAndTable.swift
//  LXC
//
//  Created by renren on 16/4/20.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit


let kNavBarAndTableCellID = "navCell"

class NavBarAndTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Comment
    /**
    
    http://ios.jobbole.com/84321/
    
    */

    
    var tableView : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSelfViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ToolBox.makeNavigationBarAlphaNo(self.navigationController!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Methods
    func buildSelfViews() {
        
        if self .responds(to: #selector(getter: UIViewController.automaticallyAdjustsScrollViewInsets)) {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.rowHeight = 90
        tableView!.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView!.backgroundColor = UIColor.red
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: kNavBarAndTableCellID)
        self.view.addSubview(tableView!)
        
        ToolBox.makeNavigationBarAlpha(self.navigationController!)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kNavBarAndTableCellID)!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    


}








