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
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if let data = STORAGE_SERVICE.search(url: (self.family?.photoURL?.absoluteString)!) {
                self.imageFamily.image = UIImage(data: data)
            }
        }
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "Agregar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(addMember(sender:)))
        
        
        self.navigationItem.rightBarButtonItem = addButton
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        family = FAMILY_SERVICE.searchFamily(id: (family?.id)!)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.loadMembers(table: self.membersTable)
        }
        NotificationCenter.default.addObserver(forName: USERS_NOTIFICATION, object: nil, queue: nil){ notification in
            self.loadMembers(table: self.membersTable)
        }
        
    }
    func addMember(sender: UIBarButtonItem) -> Void {
        self.performSegue(withIdentifier: "addMembersScreen", sender: nil)
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
                if duplicate(id: user.id) {
                    self.members.append(user)
                    table.reloadData()
                }
                
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
        if(family?.admin == member.id){
            cell.adminlabel.isHidden = false
        }else{
            cell.adminlabel.isHidden = true
        }

        
        return cell
    }
    
    func duplicate(id: String) -> Bool {
        var bool = true
        for item in self.members {
            if(item.id == id){
                bool = false
                break
            }
        }
        return bool
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addMembersScreen"){
            let viewController  = segue.destination as! AddMembersTableViewController
            viewController.family = family!
        }
    }
    
}
