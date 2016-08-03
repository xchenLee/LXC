//
//  TumblrVideoEntry0.swift
//  LXC
//
//  Created by renren on 16/8/3.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Player
import MediaPlayer

class TumblrVideoEntry0: UIView, PlayerDelegate {

    var videoThumbnail: UIImageView
    
    var indicator: UIActivityIndicatorView
    
    var videoPlayer: Player
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.videoPlayer = Player()
        
        self.indicator = UIActivityIndicatorView()
        self.indicator.size = CGSizeMake(kTMCellVideoIndicatorSize, kTMCellVideoIndicatorSize)
        
        self.videoThumbnail = UIImageView()
        self.videoThumbnail.userInteractionEnabled = true
        self.videoThumbnail.clipsToBounds = true
        self.videoThumbnail.layer.borderColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0).CGColor
        self.videoThumbnail.top = 0
        self.videoThumbnail.left = 0
        self.videoThumbnail.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        
        self.videoPlayer = Player()
        
        self.indicator = UIActivityIndicatorView()
        self.indicator.size = CGSizeMake(kTMCellVideoIndicatorSize, kTMCellVideoIndicatorSize)
        
        self.videoThumbnail = UIImageView()
        self.videoThumbnail.userInteractionEnabled = true
        self.videoThumbnail.clipsToBounds = true
        self.videoThumbnail.layer.borderColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0).CGColor
        self.videoThumbnail.top = 0
        self.videoThumbnail.left = 0
        self.videoThumbnail.size = CGSizeMake(kTMCellAvatarSize, kTMCellAvatarSize)
        
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.exclusiveTouch = true
        
        self.videoPlayer.delegate = self
        
        self.addSubview(self.videoPlayer.view)
        self.addSubview(self.videoThumbnail)
        self.addSubview(self.indicator)
        
        let thumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(tapThumbnailView))
        self.videoThumbnail .addGestureRecognizer(thumbnailGesture)
        
        let videoGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideoPlayerView))
        self.videoPlayer.view .addGestureRecognizer(videoGesture)
        
    }
    
    func tapThumbnailView(gesture: UITapGestureRecognizer) {
        
        let playerState = self.videoPlayer.playbackState.rawValue
        switch playerState {
            
        case PlaybackState.Stopped.rawValue:
            self.videoThumbnail.hidden = true
            self.videoPlayer.playFromBeginning()
            break
            
        case PlaybackState.Paused.rawValue:
            self.videoThumbnail.hidden = true
            self.videoPlayer.playFromCurrentTime()
            break
            
        case PlaybackState.Failed.rawValue:
            self.videoThumbnail.hidden = false
            self.videoPlayer.pause()
            break
            
        default:
            self.videoThumbnail.hidden = false
            self.videoPlayer.pause()
        }
    }
    
    func tapVideoPlayerView(gesture: UITapGestureRecognizer) {
        
        let playerState = self.videoPlayer.playbackState.rawValue
        
        switch playerState {
            
        case PlaybackState.Stopped.rawValue:
            self.videoPlayer.playFromBeginning()
            break
            
        case PlaybackState.Paused.rawValue:
            self.videoPlayer.playFromCurrentTime()
            break
            
        case PlaybackState.Playing.rawValue:
            self.indicator.hidden = true
            self.videoPlayer.pause()
            break
            
        case PlaybackState.Failed.rawValue:
            self.indicator.hidden = true
            self.videoPlayer.stop()
            break
            
        default:
            self.indicator.hidden = true
            self.videoPlayer.stop()
        }
        
    }
    
    // MARK: - set datas
    func setWithLayout(tumblrLayout: TumblrNormalLayout) {
        
        //视频缩略图
        guard let tumblrPost = tumblrLayout.post, let url = NSURL(string: tumblrPost.thumbnailUrl) else {
            self.videoThumbnail.frame = CGRectZero
            return
        }
        
        self.indicator.left = tumblrLayout.indicatorLeft
        self.indicator.top = tumblrLayout.indicatorTop
        
        self.videoThumbnail.frame = CGRectMake(0, 0, kScreenWidth, tumblrLayout.videoHeight)
        self.videoThumbnail.kf_setImageWithURL(url)
        
        self.videoThumbnail.hidden = false
        
        self.videoPlayer.view.frame = CGRectMake(0, 0, kScreenWidth, tumblrLayout.videoHeight)
        if !tumblrPost.videoUrl.isEmpty {
            
            guard let url = NSURL(string: tumblrPost.videoUrl) else {
                return
            }
            self.videoPlayer.setUrl(url)
        }
    }
    
    
    // MARK: - PlayerDelegate methods
    func playerReady(player: Player) {
        print("player ready")
    }
    
    func playerPlaybackStateDidChange(player: Player) {
        print("player state did change")
    }
    
    func playerBufferingStateDidChange(player: Player) {
        
        print("player buffering state change")

        if self.videoPlayer.playbackState == PlaybackState.Playing {
            self.videoThumbnail.userInteractionEnabled = true
        }
        
        let bufferingState = self.videoPlayer.bufferingState.rawValue
        
        if bufferingState == BufferingState.Delayed.rawValue{
            self.indicator.hidden = false
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
            self.indicator.hidden = true
        }
        
        switch bufferingState {
        case BufferingState.Ready.rawValue:
            print("buffering ready")
            break
        case BufferingState.Delayed.rawValue:
            print("buffering delayed")
            break
        case BufferingState.Unknown.rawValue:
            print("buffering unknown")
            break
        default:
            print("buffering default")
            break
        }

    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
        print("player will start from beginning")
    }
    
    func playerPlaybackDidEnd(player: Player) {
        //视频播放结束，显示
        self.videoThumbnail.userInteractionEnabled = true
        self.videoThumbnail.hidden = false
        print("player end")

    }

}


















