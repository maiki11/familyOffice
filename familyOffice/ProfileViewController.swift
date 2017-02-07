//
//  ProfileViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var activities : [Record] = []
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return activities.count
        }
        return 0
        
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
