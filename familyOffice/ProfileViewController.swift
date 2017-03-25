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
<<<<<<< Updated upstream
    let center = NotificationCenter.default
    var localeChangeObserver : NSObjectProtocol!
=======
    var activities : [Record] = []
>>>>>>> Stashed changes
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< Updated upstream
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
=======
        
        let profile = USER_SERVICE.user
        self.tableView.separatorStyle = .none
        DispatchQueue.global(qos: .userInitiated).async  {
            ACTIVITYLOG_SERVICE.getActivities(id: USER_SERVICE.user!.id)
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.activities = ActivityLogService.Instance().activityLog
                
            }
        }
        //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        //self.profileImage.clipsToBounds = true
        self.userName.text =  profile?.name
        if let data = STORAGE_SERVICE.search(url: (profile?.photoURL)!) {
            self.profileImage.image = UIImage(data: data)
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.activities = ActivityLogService.Instance().activityLog
        self.activities.sort(by: {$0.date > $1.date})
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
            Utility.Instance().stopLoading(view: self.view)
            self.activities = ActivityLogService.Instance().activityLog
            self.activities.sort(by: {$0.date > $1.date})
            self.tableView.reloadData()
        }
>>>>>>> Stashed changes
        
        REF_SERVICE.remove(ref:  "activityLog/\((FIRAuth.auth()?.currentUser?.uid)!)")
        REF_SERVICE.remove(ref: "notifications/\((FIRAuth.auth()?.currentUser?.uid)!)")
    }
<<<<<<< Updated upstream
=======
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
    }
>>>>>>> Stashed changes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
<<<<<<< Updated upstream
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
=======
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.Instance().logOut()
        Utility.Instance().gotoView(view: "StartView", context: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! recordTableViewCell
            let activity = activities[indexPath.row]
            cell.date.text = activity.date
            cell.activity.text = activity.activity
            cell.iconImage.image = #imageLiteral(resourceName: "logo")
            if let data = STORAGE_SERVICE.search(url: activity.photoURL) {
                cell.photo.image = UIImage(data: data)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
            return cell
        }
        
>>>>>>> Stashed changes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
<<<<<<< Updated upstream
            return ACTIVITYLOG_SERVICE.activityLog.count
        }else{
            return NOTIFICATION_SERVICE.notifications.count
        }
    }
    
=======
            return activities.count
        }
        return 0
        
    }
    
    
    
>>>>>>> Stashed changes
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
