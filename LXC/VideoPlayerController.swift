//
//  VideoPlayerController.swift
//  LXC
//
//  Created by renren on 16/8/17.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoPlayerController: UIViewController, PlayerDelegate {
    
    private var player: Player!
    private var playerBounds: CGRect!
    private var playVideoUrl: NSURL!
    
    private var mpVolumeView: MPVolumeView!
    
    // read-only 
    //
    private var originalFrame: CGRect! {
        return CGRectMake(0, (kScreenHeight - playerBounds.size.height) / 2, playerBounds.size.width, playerBounds.size.height)
    }
    
    convenience init(url: NSURL, bounds: CGRect) {
        self.init()
        self.playVideoUrl = url
        self.playerBounds = bounds
        
        //这样子背景色可以透明了
        self.modalPresentationStyle = .OverCurrentContext
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let transparentColor = UIColor.fromARGB(0x000000, alpha: 0.8)
        self.view.backgroundColor = transparentColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customInit()
    }
    
    func customInit() {
        
        // new Player
        self.player = Player()
        self.player.delegate = self
        self.player.playbackLoops = true
        self.player.enableExternalPlay()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPlayer))
        self.player.view.addGestureRecognizer(tapGesture)
        
        let panGesutre = UIPanGestureRecognizer(target: self, action: #selector(panPlayer))
        self.player.view.addGestureRecognizer(panGesutre)
        
        
        // player added and resources set
        self.addChildViewController(self.player)
        
        // store the original frame
        
        
        self.player.view.frame = self.originalFrame
        self.view.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        
        self.player.setUrl(self.playVideoUrl)
        self.player.playFromBeginning()
        
        
        // airplay
        let volumeView = MPVolumeView()
        volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = false
        volumeView.sizeToFit()
        
        let left = kScreenWidth - volumeView.size.width
        let top = kScreenHeight - volumeView.size.height - kTMCellPadding
        volumeView.frame = CGRectMake(left, top, volumeView.size.width, volumeView.size.height)
        self.view.addSubview(volumeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapPlayer(gesture: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func panPlayer(gesture: UIPanGestureRecognizer) {
        
        let touchView = gesture.view
        let offsetPoint = gesture.translationInView(self.view)
        
        var translateFrame = touchView?.frame
        translateFrame?.origin.x += offsetPoint.x
        translateFrame?.origin.y += offsetPoint.y
        
        touchView?.frame = translateFrame!
        gesture .setTranslation(CGPointZero, inView: touchView)
        
        
        if gesture.state == .Cancelled || gesture.state == .Failed || gesture.state == .Ended {
            touchView?.frame = self.originalFrame
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

        let bufferingState = self.player.bufferingState.rawValue

        
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
        print("player end")
        
    }


}
