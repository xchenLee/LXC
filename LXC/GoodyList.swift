//
//  GoodyList.swift
//  LXC
//
//  Created by renren on 16/3/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Photos

class GoodyList: UITableViewController, IImagePickerDelegate {
    
    var goodiesArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.tableView.register(UINib(nibName: "GoodyListCell", bundle:Bundle.main), forCellReuseIdentifier: "goodyCell")

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //组装数据
        generalGoodyArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func generalGoodyArray () {
        
        let quartz = GoodyItem(name: "Quartz", storyboardName: "quartz")
        goodiesArray.add(quartz)
        
        let compress = GoodyItem(name: "Compress", goodyClassName: NSStringFromClass(CompressImage))
        goodiesArray.add(compress)
        
        let ca = GoodyItem(name: "Core Animation", storyboardName: "coreAnimation")
        goodiesArray.add(ca)
        
        let splashItem = GoodyItem(name: "Splash Video", goodyClassName: NSStringFromClass(VideoBackground))
        goodiesArray .add(splashItem)
        
        let digitalScale = GoodyItem(name: "Digital Scale", goodyClassName: NSStringFromClass(DigitalScale))
        goodiesArray .add(digitalScale)
        
        let contactList = GoodyItem(name: "Contact List", goodyClassName: NSStringFromClass(PhoneContactsList))
        goodiesArray .add(contactList)
        
        let qrGenerator = GoodyItem(name: "General QR Code", goodyClassName: NSStringFromClass(QRCodeGenerator))
        goodiesArray .add(qrGenerator)
        
        let qrReader = GoodyItem(name: "Read QR Code", storyboardName: "qrStoryboard")
        goodiesArray .add(qrReader)
        
        let filters = GoodyItem(name: "CIFilters", storyboardName: "filters")
        goodiesArray .add(filters)
        
        let webview = GoodyItem(name: "WKWebView", storyboardName: "webexplorer")
        goodiesArray.add(webview)
        
        let touchId = GoodyItem(name: "Touch ID", goodyClassName: NSStringFromClass(TouchIdTest))
        goodiesArray.add(touchId)
        
        let picker = GoodyItem(name: "Picker", goodyClassName: NSStringFromClass(IImagePicker))
        picker.presetnType = PresentType.present
        goodiesArray.add(picker)
        
        let location = GoodyItem(name: "Location", goodyClassName: NSStringFromClass(PinLocation))
        goodiesArray.add(location)
        
        let navi = GoodyItem(name: "Navibar", goodyClassName: NSStringFromClass(NavBarAndTable))
        goodiesArray.add(navi)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodiesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodyCell", for: indexPath)
        
        let goodyItem = goodiesArray.object(at: indexPath.row) as? GoodyItem
        if let goodyCell = cell as? GoodyListCell {
            goodyCell.titleLabel.text = goodyItem?.goodyName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let goodyItem = goodiesArray .object(at: indexPath.row) as! GoodyItem
        
        if  goodyItem.goodyClassName.isEmpty {
            
            let sbName : String = goodyItem.storyboardName
            let goodyController = UIStoryboard(name: sbName, bundle: Bundle.main).instantiateInitialViewController()! as UIViewController
            if goodyItem.presetnType == PresentType.push {
                self.navigationController!.pushViewController(goodyController, animated: true)
            }
            else {
                self.navigationController!.present(goodyController, animated: true, completion: nil)
            }
            return
        }
        
        if let anyClass = NSClassFromString(goodyItem.goodyClassName) {
            let goodyClass = anyClass as! UIViewController.Type
            let goodyController = goodyClass.init()
            if goodyItem.presetnType == PresentType.push {
                self.navigationController!.pushViewController(goodyController, animated: true)
            }
            else {
                self.navigationController!.present(goodyController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IImagePickerDelegate
    func iImagePickerDidCancel(_ imagePicker: IImagePicker) {
    }
    
    func iImagePicker(_ imagePicker: IImagePicker, didFinishPickingAssets: [PHAsset]) {
    }
}
