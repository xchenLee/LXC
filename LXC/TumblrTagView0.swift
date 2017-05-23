//
//  TumblrTagView0.swift
//  LXC
//
//  Created by danlan on 2017/5/22.
//  Copyright © 2017年 com.demo.lxc. All rights reserved.
//

import UIKit

let kCustomDetectionTypeName = "customLinkScheme"
let kCustomDetectionTypeTag = "customTagScheme"
let kCustomDetectionTagPattern = "\\#{1}[^\\#]+\\#{1}"

typealias TapTagBlock = (_ tagText: String) -> Void

class TumblrTagView0: UITextView, UITextViewDelegate {
    
    var tapTagAction: TapTagBlock?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.delegate = self
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let detectionType = self.attributedText.attribute(kCustomDetectionTypeName, at: characterRange.location, effectiveRange: nil) as? String, detectionType == kCustomDetectionTypeTag else {
            return true
        }
        
        let text = self.text .subString(characterRange.location, length: characterRange.length)!
        
        guard text.characters.count > 2 else {
            return false
        }
        
        if !text.isEmpty && tapTagAction != nil {
            tapTagAction!(text)
        }
        return false
    }

}
