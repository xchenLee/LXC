//
//  TumblrTagPanel.swift
//  LXC
//
//  Created by danlan on 2017/5/23.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit
import SnapKit

protocol TumblrTagPanelProtocol {
    
    func tagTapped(tagName: String) -> Void
}

//class TagLabel: UILabel {
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsetsMake(0, 6, 0, 6)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
//}

class TumblrTagPanel: UIView {
    
    var tapPanelDelegate: TumblrTagPanelProtocol?
    var seperateLine: UIView!
    
    // MARK: - initial methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    func setupViews() {
        seperateLine = UIView()
        seperateLine.backgroundColor = kTMCellLineColorAlpha
        seperateLine.size = CGSize(width: kScreenWidth - 2 * kTMCellPadding, height: ToolBox.obtainFloatPixel(1))
    }
    
    // MARK: - core method to set datas
    func fitTags(_ tags: [String]) {
        self.removeAllSubViews()
        
        var blackFlag = true
        for tagName in tags {
            let tagLabel = self.tagFactory(tagName)
            let textColor = blackFlag ? UIColor.white : UIColor.black
            let backColor = blackFlag ? UIColor.black : UIColor.white
            tagLabel.textColor = textColor
            tagLabel.backgroundColor = backColor
            
            blackFlag = !blackFlag
            self.addSubview(tagLabel)
        }
        self.addSubview(self.seperateLine)
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        let maxW = kScreenWidth - 2 * kTMCellPadding
        
        var widthSum : CGFloat = 0
        var left : CGFloat = 0
        var top = kTMCellTagTSpacing
        
        // layout tagviews
        for tagView in self.subviews {
            
            let tagW = tagView.size.width
            if widthSum + kTMCellTagHSpacing + tagW <= maxW {
                if left > 0 {
                    left += kTMCellTagHSpacing
                }
            } else {
                widthSum = 0
                top += kTMCellTagVSpacing + kTMCellTagMaxH
                left = 0
            }
            tagView.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(left)
                make.top.equalTo(self).offset(top)
                make.height.equalTo(kTMCellTagMaxH)
                make.width.equalTo(tagW)
            })
            left += tagW
            widthSum += kTMCellTagHSpacing + tagW
        }
        
        // layout line view
        self.seperateLine.snp.makeConstraints { (make) in
            make.left.equalTo(kTMCellPadding)
            make.top.equalTo(self.height - 1)
            make.height.equalTo(ToolBox.obtainFloatPixel(1))
        }
    }
    
    
    // MARK: - static method to calculate the height of this widget
    static func computeHeight(_ tagsArray: [String]) -> Float {
        return 0.0
    }
    
    // MARK: - factory method to construct a tag view
    func tagFactory(_ tagName: String) -> UILabel {
        
        let lable = UILabel()
        lable.font = kTMCellTagFont
        lable.textColor = UIColor.black
//        lable.backgroundColor = UIColor.fromARGB(0xf3f3f3, alpha: 1)
        lable.backgroundColor = UIColor.white
        lable.layer.borderColor = UIColor.black.cgColor
        lable.layer.borderWidth = ToolBox.obtainFloatPixel(2)
        lable.textAlignment = .center
        lable.text = tagName
        lable.layer.cornerRadius = 5
        lable.clipsToBounds = true
        lable.lineBreakMode = .byTruncatingTail
        
        let width = tagName.widthWithConstrainedHeight(kTMCellTagMaxW, font: kTMCellTagFont)
        let widthA = min(kTMCellTagMaxW, width + 2 * kTMCellTagInsets)
        lable.size = CGSize(width: widthA, height: kTMCellTagMaxH)
        
        lable.isUserInteractionEnabled = true
        
        let tagG = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
        lable.addGestureRecognizer(tagG)
        
        return lable
    }
    
    // MARK: - Gesture event
    func tagTapped(_ gesture: UITapGestureRecognizer) {
        
        let lable = gesture.view! as! UILabel
        guard let delegate = self.tapPanelDelegate else {
            return
        }
        delegate.tagTapped(tagName: lable.text!)
    }
    

}

