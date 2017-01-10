//
//  TumblrTagView.swift
//  LXC
//
//  Created by renren on 16/8/8.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kCustomDetectionTypeName = "CustomDetectionType.detectionTypeName"
let kCustomDetectionTypeTag = "TumblrTag"
let kCustomDetectionTagPattern = "\\#{1}[^\\#]+\\#{1}"


typealias TapTagBlock = (_ tagText: String) -> Void

class TumblrTagView: UITextView, UITextViewDelegate {
    
    var tapTagAction: TapTagBlock?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let detectionType = self.attributedText.attribute(kCustomDetectionTypeName, at: characterRange.location, effectiveRange: nil) as? String, detectionType == kCustomDetectionTypeTag else {
            return true
        }
        
        let text = (self.text as NSString).substring(with: characterRange)
        guard text.characters.count > 2 else {
            return false
        }
        
        if !text.isEmpty {
            tapTagAction?(text)
        }
        return false
    }


}

