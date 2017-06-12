//
//  TumblrVideoEntry0.swift
//  LXC
//
//  Created by renren on 16/8/3.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Kingfisher

class TumblrVideoEntry0: UIView, PlayerDelegate {

    var videoFlag: UIImageView
    var videoThumbnail: UIImageView
    var indicator: UIActivityIndicatorView
    
    var videoSourceFlag : UIImageView
    
    var videoPlayer: Player
    
    var cell: TumblrNormalCell?
    
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.videoPlayer = Player()
        
        self.indicator = UIActivityIndicatorView()
        self.indicator.size = CGSize(width: kTMCellVideoIndicatorSize, height: kTMCellVideoIndicatorSize)
        
        self.videoFlag = UIImageView()
        self.videoFlag.top = 0
        self.videoFlag.contentMode = .center
        self.videoFlag.image = UIImage(named: "icon_video")
        self.videoFlag.left = kScreenWidth - kTMCellVideoFlagSize
        self.videoFlag.size = CGSize(width: kTMCellVideoFlagSize, height: kTMCellVideoFlagSize)
        
        self.videoThumbnail = UIImageView()
        self.videoThumbnail.isUserInteractionEnabled = true
        self.videoThumbnail.clipsToBounds = true
        self.videoThumbnail.layer.borderColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0).cgColor
        self.videoThumbnail.top = 0
        self.videoThumbnail.left = 0
        self.videoThumbnail.size = CGSize(width: kTMCellAvatarSize, height: kTMCellAvatarSize)
        
        
        self.videoSourceFlag = UIImageView()
        self.videoSourceFlag.contentMode = .center
        self.videoSourceFlag.size = CGSize(width: kTMCellVideoSourceFlagSize, height: kTMCellVideoSourceFlagSize)
        
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        
        
        self.videoPlayer = Player()
        
        self.indicator = UIActivityIndicatorView()
        self.indicator.size = CGSize(width: kTMCellVideoIndicatorSize, height: kTMCellVideoIndicatorSize)
        
        self.videoFlag = UIImageView()
        self.videoFlag.top = 0
        self.videoFlag.contentMode = .center
        self.videoFlag.image = UIImage(named: "icon_video")
        self.videoFlag.left = kScreenWidth - kTMCellVideoFlagSize
        self.videoFlag.size = CGSize(width: kTMCellVideoFlagSize, height: kTMCellVideoFlagSize)
        
        self.videoThumbnail = UIImageView()
        self.videoThumbnail.isUserInteractionEnabled = true
        self.videoThumbnail.clipsToBounds = true
        self.videoThumbnail.layer.borderColor = UIColor.fromARGB(0xF5F5F5, alpha: 1.0).cgColor
        self.videoThumbnail.top = 0
        self.videoThumbnail.left = 0
        self.videoThumbnail.size = CGSize(width: kTMCellAvatarSize, height: kTMCellAvatarSize)
        
        self.videoSourceFlag = UIImageView()
        self.videoSourceFlag.contentMode = .center
        self.videoSourceFlag.image = UIImage(named: "icon_video_youtube")
        self.videoSourceFlag.size = CGSize(width: kTMCellVideoSourceFlagSize, height: kTMCellVideoSourceFlagSize)
        
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        
        self.videoPlayer.delegate = self
        
        self.addSubview(self.videoPlayer.view)
        self.addSubview(self.videoThumbnail)
        self.addSubview(self.indicator)
        self.addSubview(self.videoFlag)
        self.addSubview(self.videoSourceFlag)
        
        let thumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(tapThumbnailView))
        self.videoThumbnail .addGestureRecognizer(thumbnailGesture)
        
        let videoGesture = UITapGestureRecognizer(target: self, action: #selector(tapVideoPlayerView))
        self.videoPlayer.view .addGestureRecognizer(videoGesture)
        
        let videoLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressVideoPlayerView))
        self.videoPlayer.view .addGestureRecognizer(videoLongGesture)
        
    }
    
    func tapThumbnailView(_ gesture: UITapGestureRecognizer) {
        
        
        guard let safeCell = cell, let layout = safeCell.layout else {
            return
        }
        
        if layout.outerVideo {
            /*guard let delegate = safeCell.delegate else {
                return
            }*/
            safeCell.delegate?.didClickOuterVideo(safeCell)
            return
        }
        
        
        let playerState = self.videoPlayer.playbackState.rawValue
        switch playerState {
            
        case PlaybackState.stopped.rawValue:
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.videoPlayer.playFromBeginning()
            break
            
        case PlaybackState.paused.rawValue:
            self.videoThumbnail.isHidden = true
            self.videoFlag.isHidden = true
            self.videoPlayer.playFromCurrentTime()
            break
            
        case PlaybackState.failed.rawValue:
            self.videoThumbnail.isHidden = false
            self.videoFlag.isHidden = false
            self.videoPlayer.pause()
            break
            
        default:
            self.videoThumbnail.isHidden = false
            self.videoFlag.isHidden = false
            self.videoPlayer.pause()
        }
    }
    
    func tapVideoPlayerView(_ gesture: UITapGestureRecognizer) {
        
        guard let layout = self.cell?.layout else {
            return
        }
        
        if layout.outerVideo {
            return
        }
        
        let playerState = self.videoPlayer.playbackState.rawValue
        
        switch playerState {
            
        case PlaybackState.stopped.rawValue:
            self.videoFlag.isHidden = true
            self.videoPlayer.playFromBeginning()
            break
            
        case PlaybackState.paused.rawValue:
            self.videoFlag.isHidden = true
            self.videoPlayer.playFromCurrentTime()
            break
            
        case PlaybackState.playing.rawValue:
            self.indicator.isHidden = true
            self.videoFlag.isHidden = false
            self.videoPlayer.pause()
            break
            
        case PlaybackState.failed.rawValue:
            self.indicator.isHidden = true
            self.videoPlayer.stop()
            break
            
        default:
            self.videoFlag.isHidden = false
            self.indicator.isHidden = true
            self.videoPlayer.stop()
        }
        
    }
    
    func longPressVideoPlayerView(_ gesture: UILongPressGestureRecognizer) {
        
        guard let safeCell = cell else {
            return
        }
        self.videoPlayer.pause()
        safeCell.delegate?.didLongPressVideo(safeCell)
    }
    
    // MARK: - set datas
    func setWithLayout(_ tumblrLayout: TumblrNormalLayout) {
        
        //视频缩略图
        guard let tumblrPost = tumblrLayout.post, let url = URL(string: tumblrPost.thumbnailUrl) else {
            self.videoThumbnail.frame = CGRect.zero
            self.videoSourceFlag.isHidden = true
            return
        }
        
        //如果是youtube 视频
        
        if tumblrLayout.outerVideo {
            self.videoSourceFlag.image = UIImage(named: tumblrLayout.sourceIconName)
            self.videoSourceFlag.isHidden = false
            self.videoSourceFlag.frame = CGRect(x: tumblrLayout.sourceFlagLeft, y: tumblrLayout.sourceFlagTop, width: kTMCellVideoSourceFlagSize, height: kTMCellVideoSourceFlagSize)
        } else {
            self.videoSourceFlag.image = nil
            self.videoSourceFlag.isHidden = true
            self.videoSourceFlag.frame = CGRect.zero
        }
        
        
        self.indicator.left = tumblrLayout.indicatorLeft
        self.indicator.top = tumblrLayout.indicatorTop
        
        self.videoThumbnail.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: tumblrLayout.videoHeight)
        self.videoThumbnail.kf.setImage(with: url)
        
        self.videoThumbnail.isHidden = false
        
        self.videoPlayer.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: tumblrLayout.videoHeight)
        if !tumblrPost.videoUrl.isEmpty {
            
            guard let url = URL(string: tumblrPost.videoUrl) else {
                return
            }
            self.videoPlayer.setUrl(url)
        }
    }
    
    
    // MARK: - PlayerDelegate methods
    func playerReady(_ player: Player) {
        self.videoThumbnail.isHidden = true
        self.videoFlag.isHidden = true
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        print("player ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("player state did change")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
        print("player buffering state change")

        if self.videoPlayer.playbackState == PlaybackState.playing {
            self.videoThumbnail.isUserInteractionEnabled = true
        }
        
        let bufferingState = self.videoPlayer.bufferingState.rawValue
        
        if bufferingState == BufferingState.delayed.rawValue{
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
        
        switch bufferingState {
        case BufferingState.ready.rawValue:
            print("buffering ready")
            break
        case BufferingState.delayed.rawValue:
            print("buffering delayed")
            break
        case BufferingState.unknown.rawValue:
            print("buffering unknown")
            break
        default:
            print("buffering default")
            break
        }

    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        print("player will start from beginning")
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        //视频播放结束，显示
        self.videoThumbnail.isUserInteractionEnabled = true
        self.videoThumbnail.isHidden = false
        print("player end")

    }

}


















