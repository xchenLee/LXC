//
//  PhoneContactsList.swift
//  LXC
//
//  Created by renren on 16/3/18.
//  Copyright © 2016年 com.demo.lxc. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

/**
 
 MARK :  http://www.appcoda.com/ios-contacts-framework/
 
         // Old contacts
         http://www.appcoda.com/ios-programming-import-contact-address-book/
 
 */

class PhoneContactsList: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var contactsArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "PhoneContactsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "PhoneContactsCell")
        
        let pickButonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(PhoneContactsList.performAddAction))
        navigationItem.rightBarButtonItem = pickButonItem
        
        self.requestContactsData()
    }
    
    func performAddAction() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
        contactPickerViewController.delegate = self
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    func requestContactsData() {
        AppDelegate.getAppDelegate().requestContactsAccess { (accessGranted) -> Void in
            
            if !accessGranted {
                //do nonthing
                return
            }
            
            let fetchKeys = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey,
                CNContactImageDataKey
            ]
            
            var contacts = [CNContact]()
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: fetchKeys)
            let contactStore = AppDelegate.getAppDelegate().contactStore
            do {
                try contactStore.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (contact, stop) -> Void in
                    contacts .append(contact)
                })
            }
            catch {
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.contactsArray .addObjectsFromArray(contacts)
                self.tableView.reloadData()
            })
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhoneContactsCell", forIndexPath: indexPath) as! PhoneContactsCell
        
        let contact = self.contactsArray[indexPath.row] as! CNContact
        
        if !contact.isKeyAvailable(CNContactBirthdayKey) || !contact.isKeyAvailable(CNContactImageDataKey) || !contact.isKeyAvailable(CNContactEmailAddressesKey) {
        }
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        var numberArray = [String]()
        for number in contact.phoneNumbers {
            let phoneNumber = number.value as! CNPhoneNumber
            numberArray.append(phoneNumber.stringValue)
        }
        
        if numberArray.count > 0 {
            cell.phoneLabel.text = "\(numberArray[0])"
        } else {
            cell.phoneLabel.text = "no remarks"
        }
        
        if let imageData = contact.imageData {
            cell.headView.image = UIImage(data: imageData)
        } else {
            cell.headView.image = UIImage(named: "header01")
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CNContactPickerDelegate function
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        
        //TODO  delegate
    }
    
    

}











