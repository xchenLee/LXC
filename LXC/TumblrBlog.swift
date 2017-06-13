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
let kSegCovHeight: CGFloat = 200.0

class TumblrBlog: UIViewController, MXParallaxHeaderDelegate {
    
    open var blogName: String?
    open var blogHeader: String?
    
    // MARK: - 控件UI属性
    fileprivate var segPager: MXSegmentedPager?
    fileprivate var coverBox: UIView?
    fileprivate var coverImg: UIImageView?
    fileprivate var coverTopGra: CAGradientLayer?
    fileprivate var coverBomGra: CAGradientLayer?

    
    // MARK: - 数据
    fileprivate var controllers: [UIViewController] = []
    fileprivate lazy var titles: [String] = ["Posts", "Likes"]
    
    fileprivate var blogInfo: TumblrBlogInfo?

    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        self.requestUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        self.segPager?.frame = self.view.frame
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customInit() {
        
        self.title = self.blogName ?? "Blog"
        self.view.backgroundColor = UIColor.white
        self.navBarBackgroundAlpha = 0.0
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.initCovers()
        self.initPager()
        self.constructControllers()
    }
    
    fileprivate func constructControllers() {
        
        let posts = TumblrPosts()
        posts.needAlphaBar = true
        posts.blogName = self.blogName!
        self.controllers.append(posts)
    }
    
    // MARK: - 初始化cover
    private func initCovers() {
        // Cover view
        self.coverBox = UIView()
        self.coverBox!.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kSegCovHeight)
        
        self.coverImg = UIImageView()
        self.coverImg!.frame = self.coverBox!.bounds
        self.coverImg!.image = UIImage(named: "stars")
        self.coverImg!.contentMode = .scaleAspectFill
        self.coverBox!.addSubview(self.coverImg!)
        self.coverImg!.isUserInteractionEnabled = true
        
        self.coverTopGra = CAGradientLayer()
        self.coverTopGra?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 44)
        self.coverTopGra?.colors = [UIColor.fromARGB(0xff0000, alpha: 0.3).cgColor, UIColor.clear.cgColor]
        self.coverTopGra?.locations = [NSNumber(value:0)]
        self.coverTopGra?.startPoint = CGPoint(x: 0, y: 0)
        self.coverTopGra?.endPoint = CGPoint(x: 0, y: 1)
        self.coverImg?.layer.addSublayer(self.coverTopGra!)
        
        /*self.coverBomGra = CAGradientLayer()
        self.coverBomGra?.frame = CGRect(x: 0, y: kSegCovHeight - 44, width: kScreenWidth, height: 44)
        self.coverBomGra?.colors = [UIColor.clear.cgColor, UIColor.fromARGB(0xff0000, alpha: 0.3).cgColor]
        self.coverBomGra?.locations = [NSNumber(value:0)]
        self.coverBomGra?.startPoint = CGPoint(x: 0, y: 0)
        self.coverBomGra?.endPoint = CGPoint(x: 0, y: 1)
        self.coverImg?.layer.addSublayer(self.coverBomGra!)*/
        
        if self.blogHeader != nil && self.blogHeader != "" {
            let url: URL = URL(string: self.blogHeader!)!
            self.coverImg!.kf.setImage(with: url, placeholder: UIImage(named: "stars"), options: [.transition(.fade(0.6))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    // MARK: - 初始化控件方法
    private func initPager() {
        
        // Pager View
        self.segPager = MXSegmentedPager()
        self.segPager!.delegate = self
        self.segPager!.dataSource = self
        
        self.segPager!.parallaxHeader.view = self.coverBox
        self.segPager!.parallaxHeader.delegate = self
        self.segPager!.parallaxHeader.minimumHeight = 64.0
        self.segPager!.parallaxHeader.height = 200.0
        self.segPager!.segmentedControl.segmentWidthStyle = .fixed
        self.segPager!.segmentedControl.selectionIndicatorLocation = .down
        self.segPager!.segmentedControl.selectionIndicatorColor = UIColor.orange
        self.view.addSubview(self.segPager!)
        
    }
    
    // MARK: - 主要处理头部放大逻辑处理
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        self.coverImg!.frame = self.coverBox!.bounds
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
