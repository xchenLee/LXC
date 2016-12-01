//
//  CoreAnimationLearning.swift
//  LXC
//
//  Created by renren on 16/4/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CoreAnimationLearning: UIViewController {
    
    var stackView : UIStackView?
    var childOne : UIView?
    var childTwo : UIView?
    
    lazy var alertController : UIAlertController = {
        let alertC = UIAlertController(title: "Contents", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
        return alertC;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        makeViewsManually()
        
        self.title = "Core Animation"
        makeViewsFromStoryboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Method
    func obtainDivisionRect(_ index : NSInteger) -> CGRect {
        
        let x = index == 0 ?  0 : kScreenWidth / 2
        return CGRect(x: x, y: 0, width: kScreenWidth, height: kScreenHeight)
    }
    
    func makeViewsManually() {
        //        这些代码是试图改变 view 的坐标从0.0 开始 变为 0.64
        //        self.edgesForExtendedLayout = .None
        //        self.extendedLayoutIncludesOpaqueBars = false
        //        self.modalPresentationCapturesStatusBarAppearance = false
        //        self.navigationController?.navigationBar.translucent = false
        
        self.title = "Core Animation"
        self.view.backgroundColor = UIColor.white
        
        stackView = UIStackView()
        stackView!.frame = self.view.bounds
        
        
        //.Fill               是默认值 ,添加一个会直接满屏
        //.FillProportionally 是根据大小来适当显示
        //.FillEqually 均分
        stackView!.distribution = .fillEqually
        //默认值是 .Horizontal
        stackView!.axis = .vertical
        //还没搞清楚 干嘛的
        //        stackView!.alignment = .Leading
        stackView!.spacing = 2
        
        self.view.addSubview(stackView!)
        
        self.childOne = UIView()
        self.childOne!.frame = self.view.bounds
        //        self.childOne!.frame = obtainDivisionRect(0)
        self.childOne!.backgroundColor = UIColor.red
        self.stackView!.addArrangedSubview(self.childOne!)
        
        self.childTwo = UIView()
        //        self.childTwo!.frame = obtainDivisionRect(1)
        self.childTwo!.backgroundColor = UIColor.purple
        self.stackView!.addArrangedSubview(self.childTwo!)
    }
    
    func makeViewsFromStoryboard() {
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(CoreAnimationLearning.optionsClicked))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func optionsClicked() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
