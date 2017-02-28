//
//  ProfileViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        //self.profileImage.clipsToBounds = true
        self.userName.text =  USER_SERVICE.user?.name
        if let data = STORAGE_SERVICE.search(url: (USER_SERVICE.user?.photoURL)!) {
            self.profileImage.image = UIImage(data: data)
        }
        
    }
    
    func loadData(){
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ACTIVITYLOG_SERVICE.getActivities()
        NOTIFICATION_SERVICE.getNotifications()
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(forName: SUCCESS_NOTIFICATION, object: nil, queue: nil){ notification in
            
            if self.segmentedControl.selectedSegmentIndex == 0 {
                if let _ : NotificationModel = notification.object as? NotificationModel {
                    self.tableView.insertRows(at: [IndexPath(row: NOTIFICATION_SERVICE.notifications.count-1, section: 0) ], with: .fade)
                }
            }else{
                if let _ : Record = notification.object as?  Record {
                    self.tableView.insertRows(at: [IndexPath(row: ACTIVITYLOG_SERVICE.activityLog.count-1, section: 0) ], with: .fade)
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
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
        REF_ACTIVITY.child((USER_SERVICE.user?.id)!).removeObserver(withHandle: ACTIVITYLOG_SERVICE.handle)
        //REF_NOTIFICATION.child((USER_SERVICE.user?.id)!).removeObserver(withHandle: NOTIFICATION_SERVICE.handle)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! recordTableViewCell
        cell.iconImage.image = nil
        cell.photo.image = nil
        if segmentedControl.selectedSegmentIndex == 1 {
            let activity = ACTIVITYLOG_SERVICE.activityLog[indexPath.row]
            cell.iconImage.image = #imageLiteral(resourceName: "logo")
            cell.config(title: activity.activity, date: UTILITY_SERVICE.getDate(date: activity.timestamp!))
            if let data = STORAGE_SERVICE.search(url: activity.photoURL) {
                cell.photo.image = UIImage(data: data)
            }
        }else{
            let notification = NOTIFICATION_SERVICE.notifications[indexPath.row]
            cell.config(title: notification.title, date: UTILITY_SERVICE.getDate(date: notification.timestamp))
            if let data = STORAGE_SERVICE.search(url: notification.photoURL) {
                cell.iconImage.image = UIImage(data: data) 
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
