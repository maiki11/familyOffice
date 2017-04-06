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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        //self.profileImage.clipsToBounds = true
    }
    
    func loadData(){
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        REF_SERVICE.chilAdded(ref: "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        REF_SERVICE.chilAdded(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)", byChild: "timestamp")
        self.userName.text = USER_SERVICE.users[0].name
        if !USER_SERVICE.users[0].photoURL.isEmpty, let url = USER_SERVICE.users[0].photoURL {
            self.profileImage.loadImage(urlString: url)
        }
        self.tableView.reloadData()
        localeChangeObserver = center.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
            if self.segmentedControl.selectedSegmentIndex == 0 {
                if let noti : NotificationModel = notification.object as? NotificationModel {
                    let indexPath =  IndexPath(row: NOTIFICATION_SERVICE.notifications.count-1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                    if !noti.seen {
                        self.tableView.selectRow(at:indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
                    }
                    NOTIFICATION_SERVICE.notifications.sort(by: {$0.timestamp < $1.timestamp})
                }
            }else{
                if let _ : Record = notification.object as?  Record {
                    self.tableView.insertRows(at: [IndexPath(row: ACTIVITYLOG_SERVICE.activityLog.count-1, section: 0) ], with: .fade)
                    ACTIVITYLOG_SERVICE.activityLog.sort(by: {$0.timestamp < $1.timestamp})
                }
            }
            //self.loadData()
        }
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        center.removeObserver(localeChangeObserver)
        
        REF_SERVICE.remove(ref:  "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)")
        REF_SERVICE.remove(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return ACTIVITYLOG_SERVICE.activityLog.count
        }else{
            return 1 //NOTIFICATION_SERVICE.sections.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 && (self.tableView.cellForRow(at: indexPath)?.isSelected)! {
            NOTIFICATION_SERVICE.seenNotification(index: indexPath.row)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! recordTableViewCell
        cell.iconImage.image = nil
        cell.photo.image = nil
        if segmentedControl.selectedSegmentIndex == 1 {
            let activity = ACTIVITYLOG_SERVICE.activityLog[indexPath.row]
            cell.iconImage.image = #imageLiteral(resourceName: "logo")
            cell.config(title: activity.activity, date: UTILITY_SERVICE.getDate(date: activity.timestamp!))
            if !activity.photoURL.isEmpty {
                cell.photo.loadImage(urlString: activity.photoURL)
            }
        }else{
            let notification = NOTIFICATION_SERVICE.notifications[indexPath.row]
            cell.config(title: notification.title, date: UTILITY_SERVICE.getDate(date: notification.timestamp))
            if !notification.photoURL.isEmpty {
                cell.iconImage.loadImage(urlString: notification.photoURL)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return ACTIVITYLOG_SERVICE.activityLog.count
        }else{
            return NOTIFICATION_SERVICE.notifications.count
        }
    }
    
}
