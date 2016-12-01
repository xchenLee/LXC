//
//  TumblrTagView.swift
//  LXC
//
//  Created by renren on 16/8/8.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit

let kCustomDetectionTypeName = "CustomDetectionType"
let kCustomDetectionTypeTag = "Tag"
let kCustomDetectionTagPattern = "\\#{1}[^\\#]+\\#{1}"

class TumblrTagView: UITextView, UITextViewDelegate {
    
    var tapTagAction:((_ tagText: String) -> Void)?
    
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
        
        let startIndex = text.characters.index(text.startIndex, offsetBy: 1)
        let endIndex = text.characters.index(text.endIndex, offsetBy: -1)
        
        let range = startIndex..<endIndex
        
        let tagText = text.substring(with: range)
        
        if !tagText.isEmpty {
            tapTagAction?(tagText)
        }
        return false
    }


}

