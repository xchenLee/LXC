//
//  CATransform.swift
//  LXC
//
//  Created by dreamer on 16/4/27.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import QuartzCore

class CATransform: UIViewController {
    
    /**
     
     http://foggry.com/blog/2014/08/27/coreanimationxi-lie-zhi-ji-chu-bian-huan/
     
     
     https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_affine/dq_affine.html
     
     http://www.thinkandbuild.it/introduction-to-3d-drawing-in-core-animation-part-1/
     
     
     UIView 的 Transform 是 CGAffineTransform类型，用于在二维空间做旋转，缩放和平移
     
     CGAffineTransform是一个可以和二维空间向量（例如CGPoint）做乘法的3X2的矩阵
     
     当对图层应用变换矩阵，图层矩形内的每一个点都被相应地做变换，从而形成一个新的四边形的形状。CGAffineTransform中的“仿射”的意思是无论变换矩阵用什么值，图层中平行的两条线在变换之后任然保持平行，CGAffineTransform可以做出任意符合上述标注的变换
     
     
     CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform，本章后续将会详细解释。CALayer对应于UIView的transform属性叫做affineTransform
     */
    
    let imageView = UIImageView()
    
    let imageLayer = CALayer()
    
    let imageViewLast = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = kScreenWidth
        imageView.frame = CGRect(x: (w-100)/2.0, y: 100, width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.fromARGB(0xC35050, alpha: 1.0)
        imageView.image = UIImage(named: "wukong")
        
        self.view .addSubview(imageView)
        
        imageLayer.backgroundColor = imageView.backgroundColor?.cgColor
        imageLayer.frame = CGRect(x: (w-100)/2.0, y: 300, width: 100, height: 100)
        imageLayer.contents = UIImage(named : "wukong")?.cgImage
        imageLayer.contentsScale = UIScreen.main.scale
        imageLayer.contentsGravity = kCAGravityResizeAspect
        
        self.view.layer.addSublayer(imageLayer)
        
        /**
         
         UIKit － y轴向下
         Core Graphics(Quartz) － y轴向上
         OpenGL ES － y轴向上
         
         */
        
        //make transform
        //注意我们使用的旋转常量是M_PI_4，而不是你想象的45，因为iOS的变换函数使用弧度而不是角度作为单位。弧度用数学常量pi的倍数表示，一个pi代表180度，所以四分之一的pi就是45度
        //周长 2 Pi r = 360度 = 2 Pi 弧度
        //1 弧度 ＝ 180 ／ Pi
        //180 度 ＝ Pi 弧度
<<<<<<< HEAD
        //let rotateTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
=======
        //let rotateTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
>>>>>>> optimize api
        
        //imageView.transform = rotateTransform
        
//        imageView.layer.setAffineTransform(rotateTransform)

        // Combining Transforms
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 0.5, y: 0.5);
        transform = transform.rotated(by: ToolBox.degreesToRadians(30));
        transform = transform.translatedBy(x: 200, y: 0);
        
//        imageView.layer.setAffineTransform(transform)
        //图片向右边发生了平移，但并没有指定距离那么远（200像素），另外它还有点向下发生了平移。原因在于当你按顺序做了变换，上一个变换的结果将会影响之后的变换，所以200像素的向右平移同样也被旋转了30度，缩小了50%，所以它实际上是斜向移动了100像素。
        
        //这意味着变换的顺序会影响最终的结果，也就是说旋转之后的平移和平移之后的旋转结果可能不同
        
        
        // The shear Transform
        
        //斜切变换是放射变换的第四种类型，较于平移，旋转和缩放并不常用（这也是Core Graphics没有提供相应函数的原因），但有些时候也会很有用。我们用一张图片可以很直接的说明效果（图5.5）。也许用“倾斜 slanty ”描述更加恰当
        /**
        
        |a    b    0|
        |c    d    0|
        |tx   ty   1|
        
        x=ax+cy+tx
        y=bx+dy+ty
        
        struct CGAffineTransform
        {
            CGFloat a, b, c, d;
            CGFloat tx, ty;
        };
        
        X Shear
        
        |  1   0    0 |
        |SHx   1    0 |
        |  0   0    1 |
        
        
        Y Shear
        
        |  1 ShY    0 |
        |  0   1    0 |
        |  0   0    1 |
        
        */
        var shearTransform = CGAffineTransform.identity
        shearTransform.c = -1
        shearTransform.b = 0
        
        imageView.transform = shearTransform
        
        
        // 3D Transform
        // http://wonderffee.github.io/blog/2013/10/19/an-analysis-for-transform-samples-of-calayer/
        // http://www.jianshu.com/p/9cbf52eb39dd
        
        // CG的前缀告诉我们，CGAffineTransform类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且CGAffineTransform仅仅对2D变换有效
        
        // 和CGAffineTransform类似，CATransform3D也是一个矩阵，但是和2x3的矩阵不同，
        // CATransform3D是一个可以在3维空间内做变换的4x4的矩阵
        /**
        
        struct CATransform3D
        {
            CGFloat m11, m12, m13, m14;
            CGFloat m21, m22, m23, m24;
            CGFloat m31, m32, m33, m34;
            CGFloat m41, m42, m43, m44;
        };
        
        |m11    m21    m31    m41|
        |m12    m22    m32    m42|
        |m13    m23    m33    m43|
        |m14    m24    m34    m44|
        
        
        CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
        CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
        CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
        
        
        */
        
        imageViewLast.frame = CGRect(x: (w-100)/2.0, y: 500, width: 100, height: 100)
        imageViewLast.contentMode = .scaleAspectFit
        imageViewLast.backgroundColor = UIColor.fromARGB(0xC35050, alpha: 1.0)
        imageViewLast.image = UIImage(named: "tulin")
        self.view .addSubview(imageViewLast)
        
        //http://www.cnblogs.com/xiaobaizhu/p/3994356.html
        //var tdRotate : CATransform3D = CATransform3DIdentity
        //m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。当然,z方向上得有变化才会有透视效果
        //tdRotate.m34 = -1.0 / 500
//        tdRotate = CATransform3DRotate(tdRotate, CGFloat(M_PI), 0, 1, 0)
        //imageViewLast.layer.transform = tdRotate
        

        
        
        //透视投影  Perspective Projection
        //为了做一些修正，我们需要引入投影变换（又称作z变换）来对除了旋转之外的变换矩阵做一些修改，
        //Core Animation并没有给我们提供设置透视变换的函数，因此我们需要手动修改矩阵值
        // CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34
        
        //m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，
        //d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了
        

        
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












