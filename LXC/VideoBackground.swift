//
//  VideoBackground.swift
//  LXC
//
//  Created by renren on 16/2/25.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import AVFoundation

class VideoBackground: UIViewController {
    
    var avPlayer : AVPlayer?
    var avPlayerbackView : VideoPlaybackView?
    var avPlayerItem : AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avPlayerbackView = VideoPlaybackView()
        self.avPlayerbackView?.frame = self.view.bounds
        self.avPlayerbackView!.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
        self.view.addSubview(self.avPlayerbackView!)
        
        let filePath : String = Bundle.main.path(forResource: "welcome_video", ofType: "mp4")!
        let fileUrl = URL(fileURLWithPath: filePath)
        
        self.avPlayerItem = AVPlayerItem(url: fileUrl)
        
        self.avPlayer = AVPlayer(playerItem: self.avPlayerItem!)
        self.avPlayer?.volume = 0.0
        self.avPlayerbackView?.setPlayer(self.avPlayer!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoBackground.playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:self.avPlayerItem)
        
        //self.avPlayerItem?.addObserver(self, forKeyPath: "status", options: .Initial, context:nil)
        
        //self.avPlayer?.play()
        fireNotification(0);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.avPlayer?.play()
        NSLog("view will appear");
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.avPlayer?.pause()
        NSLog("view will disappear");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playerItemDidReachEnd(_ notification: Notification) {
        let playeritem = notification.object
        (playeritem as AnyObject).seek(to: kCMTimeZero)
        self.avPlayer?.play()
    }
    
    deinit {
        self.avPlayer?.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    func pausePlayer() {
        self.avPlayer?.pause()
    }
    
    func startPlayer() {
        self.avPlayer?.play()
    }
    
    func fireActionedNotification () {
        
        

        
    }
    
    func fireNotification(_ hour : NSInteger) {
        
                
        /*let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let calendarComponents = NSDateComponents()
        calendarComponents.hour = 12;
        calendarComponents.minute = 5;
        let date = calendar.dateFromComponents(calendarComponents)*/
        
        let nextDate = Date(timeIntervalSinceNow: 60);
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = nextDate;
        localNotification.category = "categoryOne"
        localNotification.timeZone = TimeZone.current
        localNotification.alertAction = "See"
        localNotification.alertBody = "hahahah \n  hahaha"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
        //UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    }
    
    //修复时间，时间归为0秒开始
    /*func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        var dateComponets: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: dateToFix)
        
        dateComponets.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
        
        return fixedDate
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}






