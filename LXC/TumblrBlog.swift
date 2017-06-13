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
import Lottie

let kSegTabHeight: CGFloat = 40.0

class TumblrBlog: UIViewController {
    
    open var blogName: String?
    open var blogHeader: String?
    
    // MARK: - 控件UI属性
    fileprivate var segPager: MXSegmentedPager?
    fileprivate var coverView: UIImageView?
    
    fileprivate var controllers: [UIViewController] = []
    
    fileprivate var lotAnimatedView: LOTAnimationView?
    
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
        
        self.constructControllers()
    }
    
    fileprivate func constructControllers() {
        
        let posts = TumblrPosts()
        posts.needAlphaBar = true
        posts.blogName = self.blogName!
        self.controllers.append(posts)
    }
    
    // MARK: - 初始化控件
    private func initViews() {
        
        // Cover view
        self.coverView = UIImageView()
        self.coverView!.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        self.coverView!.image = UIImage(named: "stars")
        self.coverView?.contentMode = .scaleAspectFill
        self.view.addSubview(self.coverView!)
        self.coverView?.isUserInteractionEnabled = true
        
        self.lotAnimatedView = LOTAnimationView(name: "favorite_black")
        self.lotAnimatedView?.frame =  CGRect(x: 50, y: 100, width: 100, height: 100)
        self.lotAnimatedView?.contentMode = .scaleAspectFill
        self.coverView!.addSubview(self.lotAnimatedView!)
        
        if self.blogHeader != nil && self.blogHeader != "" {
            let url: URL = URL(string: self.blogHeader!)!
            self.coverView!.kf.setImage(with: url, placeholder: UIImage(named: "stars"), options: [.transition(.fade(0.6))], progressBlock: nil, completionHandler: nil)
        }
        
        // Pager View
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lotAnimatedView?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lotAnimatedView?.pause()
    }
    
    override func viewDidLayoutSubviews() {
        self.segPager?.frame = self.view.frame
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - 发请求extension
extension TumblrBlog {
    
    fileprivate func requestUserInfo() {
        
        
        TMAPIClient.sharedInstance().blogInfo(self.blogName!) { [weak self] (response, error) in

            if error != nil {
                print(" load blog info error ")
                return
            }
            
            let result = JSON(response!)
            var blogInfo = TumblrBlogInfo()
            blogInfo.sjMap(result)
            
            DispatchQueue.main.async {
                self?.blogInfo = blogInfo
                guard let sself = self , let info = sself.blogInfo else {
                    return
                }
                if info.shareLikes {
                    let likes = TumblrLikes()
                    likes.needAlphaBar = true
                    likes.blogName = sself.blogName ?? ""
                    sself.controllers.append(likes)
                    sself.segPager!.reloadData()
                }
            }
        }
    }
}

// MARK: - 分Tab接口和数据源
extension TumblrBlog: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return self.controllers.count
    }
    
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 44.0
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return self.titles[index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        let controller = self.controllers[index]
        let view = controller.view
        controller.willMove(toParentViewController: self)
        self.addChildViewController(controller)
        return view!
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, willDisplayPage page: UIView, at index: Int) {
        let controller = self.controllers[index]
        controller.didMove(toParentViewController: self)

    }
    
}
