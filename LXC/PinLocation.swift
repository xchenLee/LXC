//
//  PinLocation.swift
//  LXC
//
//  Created by renren on 16/4/11.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import CoreLocation

class PinLocation: UIViewController, CLLocationManagerDelegate {
    
    /**
     
     http://nshipster.cn/core-location-in-ios-8/
     
     */
    
    
    //懒加载
    //闭包
    lazy var locationManager : CLLocationManager = {
        
        let manager = CLLocationManager()
        manager.delegate = self
        //精度 和位置更新距离
        manager.distanceFilter = 100
        manager.desiredAccuracy =  kCLLocationAccuracyBest
        return manager
        
    }()
    
    //指针view
    lazy var arrowView : UIView = {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 15
        view.layer.allowsEdgeAntialiasing = true
        view.clipsToBounds = true
        
        let line = UIView(frame: CGRect(x: 14, y: 3, width: 2, height: 24))
        line.layer.cornerRadius = 1
        line.clipsToBounds = true
        view.addSubview(line)
        
        let redLine = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 12))
        redLine.backgroundColor = UIColor.red
        line.addSubview(redLine)
        
        let blackLine = UIView(frame: CGRect(x: 0, y: 12, width: 2, height: 12))
        blackLine.backgroundColor = UIColor.black
        line.addSubview(blackLine)
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        self.view.backgroundColor = UIColor.white
        if !CLLocationManager.locationServicesEnabled() {
            return;
        }
        
        if CLLocationManager.headingAvailable() {
            
            let arrow = self.arrowView
            let screenW = UIScreen.main.bounds.size.width
            
            arrow.frame = CGRect(x: (screenW - 50), y: 84, width: 30, height: 30)
            self.view.addSubview(arrow)
            
            self.locationManager.startUpdatingHeading()

        }
        
        //还没有决定
        self.methodForEntering(CLLocationManager.authorizationStatus())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods
    func methodForEntering( _ status : CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            
            let alertController = UIAlertController(title: "", message: "in Setting u can enable this", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        default:
            return
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 , let location = locations.last {
            
            //使用位置前要判断获取的位置是否有效
            //水平精度是或者垂直精度为零，不可用
            if location.horizontalAccuracy < 0 || location.verticalAccuracy < 0 {
                return
            }
            //太大也需要抛掉，具体多少不知道
            if location.horizontalAccuracy > 100 || location.verticalAccuracy > 50 {
                return
            }
            //海拔
            let altitude = location.altitude
            //经纬度
            let coordinate = location.coordinate
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            //方向
            let course = location.course
            //速度
            let speed = location.speed
            //几层
            //总是空的
            let floor = location.floor?.level
            
            
            NSLog("alt: \(altitude), lat: \(latitude), lon: \(longitude),\n course: \(course),\n speed: \(speed),\n floor: \(floor)")
            
            //使用完后关闭更新
            //manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        default:
            return
        }
    }
    
    //方向变化
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        //0.0 - 359.9 degrees, 0 being magnetic North
        let magneticHeading  = newHeading.magneticHeading
        //0.0 - 359.9 degrees, 0 being true North
        //let trueHeading = newHeading.trueHeading
        
        let heading : CGFloat = CGFloat(-1.0 * magneticHeading / 57.2957795)
        arrowView.transform = CGAffineTransform(rotationAngle: heading)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

























