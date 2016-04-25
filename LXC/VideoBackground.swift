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
        
        let filePath : String = NSBundle.mainBundle().pathForResource("welcome_video", ofType: "mp4")!
        let fileUrl = NSURL(fileURLWithPath: filePath)
        
        self.avPlayerItem = AVPlayerItem(URL: fileUrl)
        
        self.avPlayer = AVPlayer(playerItem: self.avPlayerItem!)
        self.avPlayer?.volume = 0.0
        self.avPlayerbackView?.setPlayer(self.avPlayer!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object:self.avPlayerItem)
        
        //self.avPlayerItem?.addObserver(self, forKeyPath: "status", options: .Initial, context:nil)
        
        //self.avPlayer?.play()
        fireNotification(0);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.avPlayer?.play()
        NSLog("view will appear");
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.avPlayer?.pause()
        NSLog("view will disappear");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        let playeritem = notification.object
        playeritem?.seekToTime(kCMTimeZero)
        self.avPlayer?.play()
    }
    
    deinit {
        self.avPlayer?.pause()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func pausePlayer() {
        self.avPlayer?.pause()
    }
    
    func startPlayer() {
        self.avPlayer?.play()
    }
    
    func fireActionedNotification () {
        
        

        
    }
    
    func fireNotification(hour : NSInteger) {
        
                
        /*let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let calendarComponents = NSDateComponents()
        calendarComponents.hour = 12;
        calendarComponents.minute = 5;
        let date = calendar.dateFromComponents(calendarComponents)*/
        
        let nextDate = NSDate(timeIntervalSinceNow: 60);
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = nextDate;
        localNotification.category = "categoryOne"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertAction = "See"
        localNotification.alertBody = "hahahah \n  hahaha"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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






