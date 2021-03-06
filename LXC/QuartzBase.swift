//
//  QuartzBase.swift
//  LXC
//
//  Created by renren on 16/5/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class QuartzBase: UIViewController {
    
    /**
     
     Graphics Context : 
            CGContextRef 类型，封装Quartz绘制图像到输出设备的信息，对应绘画模式中的page
     
     Quartz坐标系 与 UIKit坐标系 Y轴相反, Quartz通过当前矩阵变换 current transformation matrix ，CTM ,将一个独立的坐标系统映射到设备的坐标系统
     
     
     UIGraphicsBeginImageContextWithOptions 返回绘图上下文与UIKit坐标系统相同
     
     在 iOS 中，如果使用 UIImage 对象来包裹创建的 CGImage 对象，可以不需要修改 CTM。UIImage 将自动进行补偿以适用 UIKit 的坐标系统
     
     1.Window Graphics Context
            在 iOS 应用程序中，如果要在屏幕上进行绘制，需要创建一个 UIView 对象，并实现它的 drawRect: 方法
            drawRect: 方法中视图对象将为当前的绘图环境创建一个 Graphics Context。我们可以通过调用 UIGraphicsGetCurrentContext 函数来获取这个 Graphics Context
     2.Bitmap Graphics Context
     3.PDF Graphics Context
     
     
     抗锯齿
     我们可以通过调用 CGContextSetShouldAntialias 来关闭位图Graphics Context的反锯齿效果。反锯齿设置是图形状态的一部分
     
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iOS 中使用 UIGraphicsBeginImageContextWithOptions 取代 CGBitmapContextCreate 来创建 Bitmap Graphics Context 以便获得相同的坐标系
        
        //创建 Bitmap Graphics Context
        
        //最开始没有写下面这行，image nil
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        
        //拿到当前的page, bitmap
        let context = UIGraphicsGetCurrentContext()
        
        //在page上开始绘制
        context?.setFillColor(red: 1, green: 0, blue: 0, alpha: 1)
        context?.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        
        //获取到
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let screen = UIImageView()
        screen.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        screen.image = image
        
        self.view.addSubview(screen)
        
        //描边路径
        
        UIGraphicsBeginImageContext(CGSize(width: 200, height: 200))
        let context1 = UIGraphicsGetCurrentContext()
        context1?.stroke(CGRect(x: 10, y: 10, width: 180, height: 180))
        
        let screen1 = UIImageView()
        
        let image1 = UIGraphicsGetImageFromCurrentImageContext()
        screen1.frame = CGRect(x: 100, y: 210, width: 200, height: 200)
        screen1.image = image1
        self.view.addSubview(screen1)
        UIGraphicsEndImageContext()
        
//        let canvasView = CanvasView(frame: self.view.bounds)
//        self.view .addSubview(canvasView)
        
        let image2 = UIImage(named: "beauties")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 118, height: 111))
        imageView.image = image2
                
        let scratchView = ScratchView(frame: CGRect(x: 100,y: 420,width: 118,height: 111))
        scratchView.addMaskView(imageView)

        self.view.addSubview(scratchView)
        
        
        let s1img = UIImage(named: "paint01-01")
        
        let s1imgview = UIImageView()
        s1imgview.frame = CGRect(x: 40, y: 100, width: 200, height: 600)
        s1imgview.image = s1img
        
        self.view.addSubview(s1imgview)
        
        let scratch = ScratchViewOne()
        let s1imgs = UIImage(named: "paint01-01blur")

        scratch.frame = CGRect(x: 40, y: 100, width: 200, height: 600)
        scratch.fuck(s1imgs!, radius: 20)
        self.view.addSubview(scratch)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
