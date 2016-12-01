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
    
    fileprivate var player: Player!
    fileprivate var playerBounds: CGRect!
    fileprivate var playVideoUrl: URL!
    
    fileprivate var mpVolumeView: MPVolumeView!
    
    // read-only 
    //
    fileprivate var originalFrame: CGRect! {
        return CGRect(x: 0, y: (kScreenHeight - playerBounds.size.height) / 2, width: playerBounds.size.width, height: playerBounds.size.height)
    }
    
    convenience init(url: URL, bounds: CGRect) {
        self.init()
        self.playVideoUrl = url
        self.playerBounds = bounds
        
        //这样子背景色可以透明了
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        //self.player.enableExternalPlay()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPlayer))
        self.player.view.addGestureRecognizer(tapGesture)
        
        let panGesutre = UIPanGestureRecognizer(target: self, action: #selector(panPlayer))
        self.player.view.addGestureRecognizer(panGesutre)
        
        
        // player added and resources set
        self.addChildViewController(self.player)
        
        // store the original frame
        
        
        self.player.view.frame = self.originalFrame
        self.view.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        
        self.player.setUrl(self.playVideoUrl)
        
        
        // airplay
        let volumeView = MPVolumeView()
        volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = false
        volumeView.sizeToFit()
        
        let left = kScreenWidth - volumeView.size.width
        let top = kScreenHeight - volumeView.size.height - kTMCellPadding
        volumeView.frame = CGRect(x: left, y: top, width: volumeView.size.width, height: volumeView.size.height)
        self.view.addSubview(volumeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapPlayer(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    func panPlayer(_ gesture: UIPanGestureRecognizer) {
        
        let touchView = gesture.view
        let offsetPoint = gesture.translation(in: self.view)
        
        var translateFrame = touchView?.frame
        translateFrame?.origin.x += offsetPoint.x
        translateFrame?.origin.y += offsetPoint.y
        
        touchView?.frame = translateFrame!
        gesture .setTranslation(CGPoint.zero, in: touchView)
        
        
        if gesture.state == .cancelled || gesture.state == .failed || gesture.state == .ended {
            touchView?.frame = self.originalFrame
        }
        
    }
    
    func playFromBeginning() {
        self.player.playFromBeginning()
    }
    
    // MARK: - PlayerDelegate methods
    func playerReady(_ player: Player) {
        print("player ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("player state did change")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
        print("player buffering state change")

        let bufferingState = self.player.bufferingState.rawValue

        
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
        print("player end")
        
    }


}
