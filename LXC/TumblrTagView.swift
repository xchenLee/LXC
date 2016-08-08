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
let kCustomDetectionTagPattern = "\\#{1}[^\\#]+\\#"

class TumblrTagView: UITextView {
    
    var tapTagAction:((tagText: String) -> Void)?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.delegate = self
    }

}

extension TumblrTagView: UITextViewDelegate {
    
    

    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        guard let detectionType = self.attributedText.attribute(kCustomDetectionTypeName, atIndex: characterRange.location, effectiveRange: nil) as? String where detectionType == kCustomDetectionTypeTag else {
            return true
        }
        
        let text = (self.text as NSString).substringWithRange(characterRange)
        guard text.characters.count > 2 else {
            return true
        }
        
        let startIndex = text.startIndex.advancedBy(1)
        let endIndex = text.endIndex.advancedBy(-1)
        
        let range = startIndex..<endIndex
        
        let tagText = text.substringWithRange(range)
        
        if !tagText.isEmpty {
            tapTagAction?(tagText: tagText)
        }
        return true
    }
    

}
