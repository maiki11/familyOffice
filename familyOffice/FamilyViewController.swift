//
//  FamilyViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 13/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.


import UIKit
import FirebaseAuth

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var members : [User] = []
    var family : Family?
    
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var membersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyName.text = family?.name
        loadMembers(table: self.membersTable)
        if let data = STORAGE_SERVICE.search(url: (family?.photoURL?.absoluteString)!) {
            imageFamily.image = UIImage(data: data)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: USERS_NOTIFICATION, object: nil, queue: nil){ notification in
            self.loadMembers(table: self.membersTable)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: USERS_NOTIFICATION, object: nil)
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleExitFamily(_ sender: UIButton) {
        FAMILY_SERVICE.exitFamily(family: family!, uid: (FIRAuth.auth()?.currentUser?.uid)!)
        UTILITY_SERVICE.gotoView(view: "TabBarControllerView", context: self)
    }
    
    func loadMembers(table: UITableView){
        for item in family?.members?.allKeys as! [String] {
            if let user = USER_SERVICE.searchUser(uid: item){
                self.members.append(user)
            }else{
                USER_SERVICE.getUser(uid: item, mainly: false)
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyMemberTableViewCell
        let member = self.members[indexPath.row]
        cell.name.text = member.name
        if let data = STORAGE_SERVICE.search(url: member.photoURL) {
            cell.memberImage.image = UIImage(data: data)
        }else {
            cell.memberImage.image = #imageLiteral(resourceName: "profile_default")
        }
        cell.phone.text = member.phone
        
        return cell
    }
    
    
    func exist(field: String, dictionary:NSDictionary) -> String {
        if let value = dictionary[field] {
            return value as! String
        }else {
            return ""
        }
    }
    func existData(field: String, dictionary: NSDictionary) -> Data? {
        if let value = dictionary[field] {
            return (value as! Data)
        }else {
            return UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile2") )
        }
    }
    func existArray(field: String, dictionary:NSDictionary) -> [Any] {
        if let value = dictionary[field] {
            return value as! Array<Any>
        }else {
            return []
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
