//
//  CAEffect.swift
//  LXC
//
//  Created by dreamer on 16/4/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class CAEffect: UIViewController {
    
    var imageViewOne : UIImageView?
    var imageViewTwo : UIImageView?
    
    var imageViewThr : UIImageView?
    
    var imageViewFou : UIImageView?
    var imageViewFiv : UIImageView?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewOne = UIImageView()
        imageViewOne?.frame = CGRectMake(30, 84, 100, 100)
        imageViewOne!.image = UIImage(named: "tulin")
        imageViewOne!.contentMode = .ScaleAspectFit
        
        imageViewOne!.layer.shadowOpacity = 0.6
        imageViewOne!.layer.shadowColor = UIColor.redColor().CGColor
        
        self.view.addSubview(imageViewOne!)
        
        
        imageViewTwo = UIImageView()
        imageViewTwo!.frame = CGRectMake(180, 84, 100, 100)
        imageViewTwo!.layer.shadowOpacity = 0.6
        imageViewTwo!.image = UIImage(named: "tulin")
        imageViewTwo!.contentMode = .ScaleAspectFit
        imageViewTwo!.layer.shadowColor = UIColor.redColor().CGColor
        
        self.view.addSubview(imageViewTwo!)
        
        let squarePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(squarePath, nil, imageViewTwo!.bounds)
        //CGPathAddRect(squarePath, nil, imageViewTwo!.bounds)
        imageViewTwo!.layer.shadowPath = squarePath
        
        //更复杂的形状可以用UIBezierPath去做
        
        //Layer Masking
        //有时候你想展示的内容不是矩形的，可能是星星状的
        // using a 32-bit PNG image with an alha component, you can specify a backing image 
        // includes an arbtrary alpha mask, which is the simplest way to create a non-rectangular view
        // but the approach  doesn't allow you to clip images dynamically using programmatically
        // generated masks or to have sublayers or subviews that also clip to the same arbtrary shape
        //使用一个32位有alpha通道的png图片通常是创建一个无矩形视图最方便的方法，你可以给它指定一个透明蒙板来实现。但是这个方法不能让你以编码的方式动态地生成蒙板，也不能让子图层或子视图裁剪成同样的形状。
        
        //CALayer 有个属性 mask也是CALayer, 它定义了parent layer's 可见部分
        // mask 的颜色 是irrelevant 无关紧要的，最重要的是它的 silhouette 轮廓
        // mask属性就像是一个饼干切割机，mask图层实心的部分会被保留下来，其他的则会被抛弃
        // 如果mask图层比父图层要小，只有在mask图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来。
        
        
        imageViewThr = UIImageView()
        imageViewThr!.frame = CGRectMake(30, 220, 100, 100)
        imageViewThr!.backgroundColor = UIColor.redColor()
        self.view .addSubview(imageViewThr!)
        
        let maskLayer = CALayer()
        maskLayer.contents = UIImage(named: "wukong")?.CGImage
        maskLayer.contentsScale = UIScreen.mainScreen().scale
        maskLayer.frame = imageViewThr!.bounds
        maskLayer.contentsGravity = kCAGravityResizeAspect
        
        imageViewThr!.layer.mask = maskLayer
        //CALayer蒙板图层真正厉害的地方在于蒙板图不局限于静态图。任何有图层构成的都可以作为mask属性，这意味着你的蒙板可以通过代码甚至是动画实时生成
        
        
        // minificationFilter和magnificationFilter属性
        // 当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）因为
        //能够显示最好的画质，像素既没有被压缩也没有被拉伸。
        //能更好的使用内存，因为这就是所有你要存储的东西。
        //最好的性能表现，CPU不需要为此额外的计算。
        
        //不过有时候，显示一个非真实大小的图片确实是我们需要的效果。比如说一个头像或是图片的缩略图，再比如说一个可以被拖拽和伸缩的大图。这些情况下，为同一图片的不同大小存储不同的图片显得又不切实际。
        
        //当图片需要显示不同的大小的时候，有一种叫做拉伸过滤的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。
        
        //事实上，重绘图片大小也没有一个统一的通用算法。这取决于需要拉伸的内容，放大或是缩小的需求等这些因素。CALayer为此提供了三种拉伸过滤方法，他们是：
        
        kCAFilterLinear
        kCAFilterNearest
        kCAFilterTrilinear
        
        //minification（缩小图片）和magnification（放大图片）默认的过滤器都是kCAFilterLinear，这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
        
        //kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果。
        
        //这个方法的好处在于算法能够从一系列已经接近于最终大小的图片中得到想要的结果，也就是说不要对很多像素同步取样。这不仅提高了性能，也避免了小概率因舍入错误引起的取样失灵的问题
        
        //kCAFilterNearest是一种比较武断的方法。从名字不难看出，这个算法（也叫最近过滤）就是取最近的单像素点而不管其他的颜色。这样做非常快，也不会使图片模糊。但是，最明显的效果就是，会使得压缩图片更糟，图片放大之后也显得块状或是马赛克严重
        
        
        
        
        
        
        
        //UIView有一个叫做alpha的属性来确定视图的透明度。
        //CALayer有一个等同的属性叫做opacity，这两个属性都是影响子层级的。也就是说，如果你给一个图层设置了opacity属性，那它的子图层都会受此影响
        
        //理想状况下，当你设置了一个图层的透明度，你希望它包含的整个图层树像一个整体一样的透明效果。
        //你可以通过设置Info.plist文件中的UIViewGroupOpacity为YES来达到这个效果，但是这个设置会影响到这个应用，整个app可能会受到不良影响。
        //如果UIViewGroupOpacity并未设置，iOS 6和以前的版本会默认为NO
        //另一个方法就是，你可以设置CALayer的一个叫做shouldRasterize属性.来实现组透明的效果，如果它被设置为YES，在应用透明度之前，图层及其子图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了
        
        let aView = UIView()
        aView.frame = CGRectMake(30, 340, 120, 120)
        aView.backgroundColor = UIColor.redColor()
        aView.alpha = 0.5
        self.view.addSubview(aView)
        
        imageViewFou = UIImageView()
        imageViewFou!.frame = CGRectMake(10, 10, 100, 100)
        imageViewFou!.contentMode = .ScaleAspectFit
        imageViewFou!.image = UIImage(named: "wukong")
        aView.addSubview(imageViewFou!)
        
        
        let bView = UIView()
        bView.frame = CGRectMake(170, 340, 120, 120)
        bView.backgroundColor = UIColor.redColor()
        bView.layer.shouldRasterize = true
        bView.alpha = 0.5
        bView.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.view.addSubview(bView)
        
        imageViewFiv = UIImageView()
        imageViewFiv!.frame = CGRectMake(10, 10, 100, 100)
        imageViewFiv!.contentMode = .ScaleAspectFit
        imageViewFiv!.image = UIImage(named: "wukong")
        bView.addSubview(imageViewFiv!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
