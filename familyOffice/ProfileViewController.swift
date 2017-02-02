//
//  ProfileViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 06/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let userService = UserService.Instance()
    var activities : [Record] = []
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = userService.user
        ActivityLogService.Instance().getActivities(id: userService.user!.id)
        //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        //self.profileImage.clipsToBounds = true
        self.userName.text =  profile?.name
        self.profileImage.image = UIImage(data: (profile?.photo)! as Data)
        self.logOutButton.layer.borderColor = UIColor(red: 32.0/255, green: 53.0/255, blue:88.0/255, alpha: 1.0).cgColor 
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
       tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(SUCCESS_NOTIFICATION)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        AuthService.authService.logOut()
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
            if(activity.photo != nil){
                cell.photo.image = UIImage(data: activity.photo!)
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
