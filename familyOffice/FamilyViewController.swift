//
//  FamilyViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 13/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var families : [Family] = []
    var ref: FIRDatabaseReference!
    @IBOutlet weak var familyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com")
        let familyService = FamilyService()
        print(familyService.getFamiliesIds() as [String])
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData(tableView: familyTableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
    
    @nonobjc func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let familyItem = families[indexPath.row]
            self.ref.child("/users/\((FIRAuth.auth()?.currentUser?.uid)!)/families").child(familyItem.id).removeValue()
            self.ref.child("/families/").child(familyItem.id).child("members/\((FIRAuth.auth()?.currentUser?.uid)!)").removeValue()
            self.families.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let family = families[indexPath.row]
        let cellID = "cell"
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellID , for: indexPath) as! FamilyTableViewCell
        cell.name.text = family.name
        cell.myImage?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
        cell.myImage?.clipsToBounds = true
        cell.myImage?.image = family.photo
        
        
        return (cell)
    }
    
    
    func reloadData(tableView: UITableView) {
        self.ref.child("/users/\((FIRAuth.auth()?.currentUser?.uid)!)/families").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let refFamily = self.ref.child("/families/")
            self.families = []
            for item in value?.allKeys as! [String] {
                refFamily.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let url = NSURL(string: value?["photoUrl"] as! String)
                    let data = NSData(contentsOf:url! as URL)
                    let model = Family(name: value!["name"] as! String, photoURL: url! , photo: UIImage(data: data as! Data)!)
                    model.id = item
                    self.families.append(model)
                    tableView.reloadData()
                })
            }
            
        }) { (error) in
            print(error.localizedDescription)
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
