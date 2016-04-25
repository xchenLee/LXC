//
//  IImagePickerAssetPop.swift
//  LXC
//
//  Created by renren on 16/4/6.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

class IImagePickerAssetPop: UIViewController {
    
    var assetDisplayView = UIImageView()
    
    // MARK: - Preview action items.
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(title: String, style: UIPreviewActionStyle = .Default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
//                guard let detailViewController = viewController as? IImagePickerAssetPop,
//                    item = detailViewController.detailTitle else { return }
//                
//                print("\(previewAction.title) triggered from `DetailsViewController` for item: \(item)")
            }
        }
        
        let actionDefault = previewActionForTitle("Default Action")
        let actionDestructive = previewActionForTitle("Destructive Action", style: .Destructive)
        
        let subActionGoTo = previewActionForTitle("Go to coordinates")
        let subActionSave = previewActionForTitle("Save location")
        let groupedOptionsActions = UIPreviewActionGroup(title: "Options…", style: .Default, actions: [subActionGoTo, subActionSave] )
        
        return [actionDefault, actionDestructive, groupedOptionsActions]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        assetDisplayView.frame = self.view.bounds
        assetDisplayView.backgroundColor = UIColor.redColor()
        self.view.addSubview(assetDisplayView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        return previewDetailsActions
    }

}
