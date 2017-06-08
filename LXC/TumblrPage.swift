//
//  TumblrPage.swift
//  LXC
//
//  Created by lxc on 2017/5/27.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

let kSegTabHeight: CGFloat = 40.0

class TumblrPage: UIViewController, LJScrollViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var testCover: UIImageView?
    var scrollView: LJScrollView?
    
    var uitableView: UITableView?
    
    var pagerView: LJPager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    func customInit() {
        
        self.title = "blog"
        self.view.backgroundColor = UIColor.white
        self.navBarBackgroundAlpha = 0.0
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.testCover = UIImageView()
        self.testCover!.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        self.testCover!.image = UIImage(named: "stars")
        self.testCover?.contentMode = .scaleAspectFill
        self.view.addSubview(self.testCover!)
        self.testCover?.isUserInteractionEnabled = true
        
        let btn = UIButton(type: .system)
        btn.setTitle("ssssss", for: .normal)
        btn.frame = CGRect(x: 40, y: 80, width: 80, height: 40)
        self.testCover?.addSubview(btn)
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        let segTitles = ["Posts", "Likes"]
        let control = LJSegControl(segTitles)
        control.indicatorHeight = 3.0
        control.frame = CGRect(x: 0, y: self.testCover!.bottom, width: kScreenWidth, height: kSegTabHeight)
        //self.view.addSubview(control)
        
//        self.scrollView = LJScrollView()
//        self.scrollView?.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
//        self.view.addSubview(self.scrollView!)
//        self.scrollView?.delegate = self
//        self.scrollView?.parallaxHeader.header = self.testCover
//        self.scrollView?.parallaxHeader.defaultHeight = 300
//        self.scrollView?.parallaxHeader.minimumHeight = 64
        
//        self.uitableView = UITableView()
//        self.uitableView!.delegate = self
//        self.uitableView!.dataSource = self
//        self.scrollView?.addSubview(self.uitableView!)
        self.testPager()
    }
    
    func testPager() {
        self.pagerView = LJPager()
        self.pagerView?.delegate = self
        self.pagerView?.pagerDataSource = self
        self.pagerView?.frame = self.view.bounds
        self.view.addSubview(self.pagerView!)
    }
    
    func clickBtn() {
        print("ssssssssssssssssss")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //self.scrollView?.frame = self.view.frame
        //self.scrollView?.contentSize = self.view.frame.size
        
        //self.uitableView?.frame = self.view.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func scrollView(_ scrollView: LJScrollView, scrollWithSubView: UIScrollView) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let idd = "tttt"
        var cell = tableView.dequeueReusableCell(withIdentifier: idd)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idd)
        }
        cell?.textLabel?.text = "sss"
        return cell!
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TumblrPage: LJPagerProtocol, LJPagerDataSource {
    
    func pagerWillMove(_ pager: LJPager, toPage: UIView, index: Int) {
        
    }
    func pagerDidMove(_ pager: LJPager,toPage: UIView, index: Int) {
        
    }
    func pagerWillDisplay(_ pager: LJPager, page: UIView, index: Int) {
        
    }
    func pagerEndDisplay(_ pager: LJPager, page: UIView, index: Int) {
        
    }
    
    func numberOfPages(inPager: LJPager) -> Int {
        return 3
    }
    func viewForPager(pager: LJPager, atIndex: Int) -> UIView {
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = (atIndex == 1 ? UIColor.red: UIColor.blue)
        return view
    }
    
}
