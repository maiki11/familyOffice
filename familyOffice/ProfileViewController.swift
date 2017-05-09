//
//  ProfileViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let center = NotificationCenter.default
    var localeChangeObserver : NSObjectProtocol!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    public var x = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
<<<<<<< HEAD
        Constants.Services.REF_SERVICE.valueSingleton(ref: "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)")
        Constants.Services.REF_SERVICE.chilAdded(ref: "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        Constants.Services.REF_SERVICE.chilAdded(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        self.userName.text = Constants.Services.USER_SERVICE.users[0].name
        if !Constants.Services.USER_SERVICE.users[0].photoURL.isEmpty, let url = Constants.Services.USER_SERVICE.users[0].photoURL {
=======
        REF_SERVICE.chilAdded(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        REF_SERVICE.chilAdded(ref: "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        self.userName.text = USER_SERVICE.users[0].name
        if !USER_SERVICE.users[0].photoURL.isEmpty, let url = USER_SERVICE.users[0].photoURL {
>>>>>>> maiki11
            self.profileImage.loadImage(urlString: url)
        }
        //ACTIVITYLOG_SERVICE.getSections()
        self.tableView.reloadData()
<<<<<<< HEAD
        localeChangeObserver = center.addObserver(forName: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
            if self.segmentedControl.selectedSegmentIndex == 0 {
                if let noti : NotificationModel = notification.object as? NotificationModel {
                    let indexPath =  IndexPath(row: Constants.Services.NOTIFICATION_SERVICE.notifications.count-1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                    if !noti.seen {
                        self.tableView.selectRow(at:indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
                    }
                    Constants.Services.NOTIFICATION_SERVICE.notifications.sort(by: {$0.timestamp < $1.timestamp})
                }
            }else{
                if let _ : Record = notification.object as?  Record {
                    self.tableView.insertRows(at: [IndexPath(row: Constants.Services.ACTIVITYLOG_SERVICE.activityLog.count-1, section: 0) ], with: .fade)
                    Constants.Services.ACTIVITYLOG_SERVICE.activityLog.sort(by: {$0.timestamp < $1.timestamp})
=======
        localeChangeObserver = center.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
            if self.segmentedControl.selectedSegmentIndex == 1 {
                print(ACTIVITYLOG_SERVICE.sec)
                if let _ : SectionNotification = notification.object as?  SectionNotification {
                    if self.tableView.numberOfSections != ACTIVITYLOG_SERVICE.sec.count {
                        //TODO: insert Section
                        let indexSet = IndexSet(integer: ACTIVITYLOG_SERVICE.sec.count)
                        self.tableView.insertSections(indexSet, with: .fade)
                    }
                    let indexPath = IndexPath(row:  ACTIVITYLOG_SERVICE.sec[ACTIVITYLOG_SERVICE.sec.count-1].record.count-1, section:ACTIVITYLOG_SERVICE.sec.count-1)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
            }else{
                if let _ : NotificationModel = notification.object as? NotificationModel {
                    self.tableView.reloadData()
                    //print("hola----------------------------")
//                    print(NOTIFICATION_SERVICE.sections)
                    //print(self.tableView.numberOfSections)
                    //print("adios----------------------------")
                    /*if self.tableView.numberOfSections != NOTIFICATION_SERVICE.sections.count {
                        let indexSet = IndexSet(integer: NOTIFICATION_SERVICE.sections.count )
                        self.tableView.insertSections(indexSet, with: .fade)
                    }*/
//                    let indexPath = IndexPath(row: NOTIFICATION_SERVICE.sections[NOTIFICATION_SERVICE.sections.count-1].record.count-1, section: 1)
//                    self.tableView.insertRows(at: [indexPath], with: .fade)
>>>>>>> maiki11
                }
            }
        }
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        center.removeObserver(localeChangeObserver)
<<<<<<< HEAD
        
        Constants.Services.REF_SERVICE.remove(ref:  "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)")
        Constants.Services.REF_SERVICE.remove(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)")
=======
        REF_SERVICE.remove(ref:  "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)")
        REF_SERVICE.remove(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)")
>>>>>>> maiki11
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return ACTIVITYLOG_SERVICE.sec.count
        }
        return NOTIFICATION_SERVICE.sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 && (self.tableView.cellForRow(at: indexPath)?.isSelected)! {
            Constants.Services.NOTIFICATION_SERVICE.seenNotification(index: indexPath.row)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! recordTableViewCell
        cell.iconImage.image = nil
        cell.photo.image = nil
//        print("-------Noti------------------------------")
//        print(NOTIFICATION_SERVICE.sections)
//        print("-----------EndNoti--------------------------")
        if segmentedControl.selectedSegmentIndex == 1 {
<<<<<<< HEAD
            let activity = Constants.Services.ACTIVITYLOG_SERVICE.activityLog[indexPath.row]
            cell.iconImage.image = #imageLiteral(resourceName: "logo")

            cell.config(title: activity.activity, date: Constants.Services.UTILITY_SERVICE.getDate(date: activity.timestamp!))
            if !activity.photoURL.isEmpty {
                cell.photo.loadImage(urlString: activity.photoURL)
            }
        }else{
            let notification = Constants.Services.NOTIFICATION_SERVICE.notifications[indexPath.row]
            cell.config(title: notification.title, date: Constants.Services.UTILITY_SERVICE.getDate(date: notification.timestamp))
=======
            let item = ACTIVITYLOG_SERVICE.sec[indexPath.section].record[indexPath.row]
            cell.iconImage.image = #imageLiteral(resourceName: "logo")
            cell.config(title: item.activity, date: UTILITY_SERVICE.getDate(date: item.timestamp!))
            if !item.photoURL.isEmpty {
                cell.photo.loadImage(urlString: item.photoURL)
            }
        }else{
            //print("porque: ",x)
            self.x += 1
            let notification = NOTIFICATION_SERVICE.sections[indexPath.section].record[indexPath.row]
            cell.config(title: notification.title, date: UTILITY_SERVICE.getDate(date: notification.timestamp))
>>>>>>> maiki11
            if !notification.photoURL.isEmpty {
                cell.iconImage.loadImage(urlString: notification.photoURL)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
<<<<<<< HEAD
            return Constants.Services.ACTIVITYLOG_SERVICE.activityLog.count
        }else{
            return Constants.Services.NOTIFICATION_SERVICE.notifications.count
=======
            return ACTIVITYLOG_SERVICE.sec[section].record.count
        }
        print("-------Rows------------------------------")
        print(NOTIFICATION_SERVICE.sections[section].record.count)
        print("-----------EndRows--------------------------")
        return NOTIFICATION_SERVICE.sections[section].record.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 1 {
            if(ACTIVITYLOG_SERVICE.sec.count>0){
                return ACTIVITYLOG_SERVICE.sec[section].date
            }
        }else{
            if(NOTIFICATION_SERVICE.sections.count>0){
                return NOTIFICATION_SERVICE.sections[section].date
            }
>>>>>>> maiki11
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 22))
        returnedView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.1764705882, blue: 0.5019607843, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10, y: 3, width: returnedView.frame.width, height: 22))
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if segmentedControl.selectedSegmentIndex == 1 {
            if(ACTIVITYLOG_SERVICE.sec.count>0){
                label.text = ACTIVITYLOG_SERVICE.sec[section].date
            }
        }else{
            if(NOTIFICATION_SERVICE.sections.count>0){
                label.text = NOTIFICATION_SERVICE.sections[section].date
            }
        }
        returnedView.addSubview(label)
        return returnedView
    }
    
}
