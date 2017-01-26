//
//  FamilyViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 13/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.


import UIKit
import Firebase

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var members : [usermodel] = []
    var family : Family?
    var ref: FIRDatabaseReference!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var membersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyName.text = family?.name
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com")
        loadMembers(table: self.membersTable)
        
        imageFamily.image = UIImage(data: (family?.photoData)!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadMembers(table: UITableView){
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com")
        ref.child("/families/\((self.family?.id)!)/members").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let refUsers = self.ref.child("/users/")
            for item in value?.allKeys as! [String] {
                refUsers.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    var url : NSURL
                    var data : Any
                    if(snapshot.exists()){
                        if ((value?["photoUrl"]) != nil) {
                            url = (NSURL(string: (value?["photoUrl"] as? String)!) ?? nil)!
                            data = NSData(contentsOf:url as URL)!
                        } else {
                            data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile"))! as NSData
                        }
                        
                        let xuser = usermodel(name: self.exist(field: "name", dictionary: value!), phone: self.exist(field: "phone", dictionary: value!), photo: data as! NSData, families: [], family: nil)
                        self.members.append(xuser)
                        table.reloadData()

                    }
                    
                }) { (error) in
                    
                }
            }
        }) { (error) in
            print(error.localizedDescription)
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
        cell.memberImage.image = UIImage(data: member.photo as Data)
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
