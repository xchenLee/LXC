//
//  VideoPlaybackView.swift
//  LXC
//
//  Created by renren on 16/2/26.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlaybackView: UIView {
    
    var avPlayer : AVPlayer?
    
    func setPlayer(_ player : AVPlayer) {
        let playerLayer = self.layer as! AVPlayerLayer
        playerLayer.player = player
    }
    
    func getPlayer() -> AVPlayer {
        let playerLayer = self.layer as! AVPlayerLayer
        return playerLayer.player!
    }
    
    func setVideoFillMode(_ mode : String) {
        let playerLayer = self.layer as! AVPlayerLayer
        playerLayer.videoGravity = mode
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    

}
