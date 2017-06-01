//
//  Extensions+UIView.swift
//  LXC
//
//  Created by renren on 16/7/30.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Base property
    
    var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var right : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    
    var centerX : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width / 2
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width / 2
        }
    }
    
    var centerY : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height / 2
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height / 2
        }
    }
    
    var origin : CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            self.frame.origin = newValue
        }
    }
    
    var size : CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    // MARK: - Snapshot of view
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap!
    }
    
    func snapshotImageAfterScreenUpdates(_ afterUpdate: Bool) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterUpdate)
        let snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap!
    }
    
    // MARK: - remove subviews
    func removeAllSubViews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
}

extension UINavigationBar {
    
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}


/**
 
 iOS 10  :_UIBarBackground
 iOS 10 before: _UINavigationBarBackground
 
 */
extension UINavigationBar {
    
    func lt_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            overlay = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height+20))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = UIViewAutoresizing.flexibleWidth
            subviews.first?.insertSubview(overlay!, at: 0)
        }
        overlay?.backgroundColor = backgroundColor
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("_UIBarBackground") as! UIView.Type) {
                element.isHidden = true
            }
        }
    }
    
    func lt_setTranslationY(translationY: CGFloat) {
        transform = CGAffineTransform.init(translationX: 0, y: translationY)
    }
    
    
    func lt_setElementsAlpha(alpha: CGFloat) {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type)
            {
                element.alpha = alpha
            }
            
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        items?.forEach({ (item) in
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
    
    
    func lt_reset() {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("_UIBarBackground") as! UIView.Type) {
                element.isHidden = false
            }
        }
        setBackgroundImage(nil, for: UIBarMetrics.default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
