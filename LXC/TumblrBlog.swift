//
//  TumblrPage.swift
//  LXC
//
//  Created by lxc on 2017/5/27.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit
import MXSegmentedPager
import TMTumblrSDK
import SwiftyJSON
import Kingfisher

let kSegTabHeight: CGFloat = 40.0

class TumblrBlog: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    open var blogName: String?
    open var blogHeader: String?
    
    // MARK: - 控件UI属性
    fileprivate var segPager: MXSegmentedPager?
    fileprivate var coverView: UIImageView?
    
    var uitableView: UITableView?
    var uiView: UIView?
    
    fileprivate var blogInfo: TumblrBlogInfo?
    lazy var titles: [String] = ["Posts", "Likes"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        
        self.requestUserInfo()
    }
    
    func customInit() {
        
        self.title = self.blogName ?? "Blog"
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
        
        if self.blogHeader != nil {
            let url: URL = URL(string: self.blogHeader!)!
            self.coverView!.kf.setImage(with: url, placeholder: UIImage(named: "stars"), options: [.transition(.fade(0.6))], progressBlock: nil, completionHandler: nil)
        }

        
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
        
        self.segPager = MXSegmentedPager()
        self.segPager!.delegate = self
        self.segPager!.dataSource = self
        
        self.segPager!.parallaxHeader.view = self.coverView
        self.segPager!.parallaxHeader.minimumHeight = 64.0
        self.segPager!.parallaxHeader.height = 200.0
        self.segPager!.segmentedControl.segmentWidthStyle = .fixed
        self.segPager!.segmentedControl.selectionIndicatorLocation = .down
        self.segPager!.segmentedControl.selectionIndicatorColor = UIColor.orange
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
        cell?.textLabel?.text = "sssxcscsdsdsdsdwfwefwefwefewfwff"
        return cell!
    }
    
}

// MARK: - 发请求extension
extension TumblrBlog {
    
    fileprivate func requestUserInfo() {
        TMAPIClient.sharedInstance().blogInfo(self.blogName!) { (response, error) in
            
            if error != nil {
                print(" load blog info error ")
                return
            }
            
            let result = JSON(response)
            var blogInfo = TumblrBlogInfo()
            blogInfo.sjMap(result)
            self.blogInfo = blogInfo
        }
    }
}

// MARK: - 分Tab接口和数据源
extension TumblrBlog: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return self.titles.count
    }
    
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 44.0
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return self.titles[index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        if index == 0 {
            return self.uitableView!
        } else {
            return self.uiView!
        }
    }
    
}
