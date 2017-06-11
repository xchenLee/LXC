//
//  TumblrPage.swift
//  LXC
//
//  Created by lxc on 2017/5/27.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

let kSegTabHeight: CGFloat = 40.0

class TumblrPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    fileprivate var segPager: LJSegPager?
    fileprivate var coverView: UIImageView?
    
    var uitableView: UITableView?
    var uiView: UIView?
    
    lazy var titles: [String] = ["Posts", "Likes"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    func customInit() {
        
        self.title = "blog"
        self.view.backgroundColor = UIColor.white
        self.navBarBackgroundAlpha = 0.0
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.initViews()
    }
    
    // MARK: - 初始化控件
    private func initViews() {
        self.coverView = UIImageView()
        self.coverView!.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        self.coverView!.image = UIImage(named: "stars")
        self.coverView?.contentMode = .scaleAspectFill
        self.view.addSubview(self.coverView!)
        self.coverView?.isUserInteractionEnabled = true
        
        let btn = UIButton(type: .system)
        btn.setTitle("ssssss", for: .normal)
        btn.frame = CGRect(x: 40, y: 80, width: 80, height: 40)
        self.coverView?.addSubview(btn)
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        self.uitableView = UITableView()
        self.uitableView!.delegate = self
        self.uitableView!.dataSource = self
        
        self.uiView = UIView()
        self.uiView?.frame = self.view.bounds
        
        self.segPager = LJSegPager()
        self.segPager!.delegate = self
        self.segPager!.dataSource = self
        
        self.segPager!.paralaxHeader?.header = self.coverView
        self.segPager!.paralaxHeader?.minimumHeight = 64.0
        self.segPager!.paralaxHeader?.defaultHeight = 180.0
        
        self.segPager?.segControl.indicatorColor = UIColor.orange
        self.view.addSubview(self.segPager!)
        
    }

    func clickBtn() {
        print("ssssssssssssssssss")
    }
    
    override func viewDidLayoutSubviews() {
        self.segPager?.frame = self.view.frame
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func scrollView(_ scrollView: LJScrollView, scrollWithSubView: UIScrollView) -> Bool {
        return false
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
    
}

extension TumblrPage: LJSegPagerProtocol, LJSegPagerDataSource {
    
    
    // MARK: - LJSegPagerProtocol
    func segPager(_ pager: LJSegPager, didSelectView: UIView) {}
    func segPager(_ pager: LJSegPager, didSelectViewWithTitle: String) {}
    func segPager(_ pager: LJSegPager, didSelectIndex: NSInteger) {}
    
    func segPager(_ pager: LJSegPager, willDisplayView: UIView, atIndex: NSInteger) {}
    func segPager(_ pager: LJSegPager, endDisplayView: UIView, atIndex: NSInteger) {}
    
    func segPagerControlHeight(_ pager: LJSegPager) -> CGFloat {
        return 44.0
    }
    
    func segPager(_ pager: LJSegPager, didScrollWithHeader: LJParallaxHeader) {}
    func segPager(_ pager: LJSegPager, didEndDragWithHeader: LJParallaxHeader) {}
    
    func pagerShouldScrollToTop(_ pager: LJSegPager) -> Bool {
        return true
    }
    
    // MARK: - LJSegPagerDataSource
    func numberOfPages(_ inSegPager: LJSegPager) -> Int {
        return titles.count
    }
    
    func title(_ pager: LJSegPager, atIndex: Int) -> String {
        return self.titles[atIndex]
    }
    
    func viewForPageAtIndex(_ segPager: LJSegPager, index: Int) -> UIView {
        if index == 0 {
            return self.uitableView!
        } else {
            return self.uiView!
        }
    }
    
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
