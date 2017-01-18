//
//  FamilyTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 16/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class FamilyTableViewController: UITableViewController {
    var families : [Family] = []
    var ref: FIRDatabaseReference!
    var family : Family?
    @IBOutlet weak var familyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com")
        let familyService = FamilyService()
        print(familyService.getFamiliesIds() as [String])
        reloadData(tableView: self.tableView)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return families.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyTableViewCell

        let family = families[indexPath.row]
        cell.name.text = family.name
        cell.imageFamily.image = family.photo
        cell.members.text = "\(family.totalMembers) Miembros"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        family = families[indexPath.row]
        self.performSegue(withIdentifier: "changeScreen", sender: nil)
    }
   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
   
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Más") { action, index in
            print("more button tapped")
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Eliminar") { action, index in
            print(indexPath.row)
            //self.delete(index: indexPath.row)
        }
        more.backgroundColor = UIColor.lightGray
        
        return [more,delete]
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
                    let model = Family(name: value!["name"] as! String, photoURL: url! , photo: UIImage(data: data as! Data)!, active: false)
                    model.id = item
                    refFamily.child(item).child("members").observeSingleEvent(of: .value, with: { (snapshot)  in
                        model.totalMembers = snapshot.childrenCount
                        self.families.append(model)
                        tableView.reloadData()
                    })
                   
                })
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func delete(index: Int)  {
        let family: Family = self.families[index]
        families.remove(at: index)
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("families").child(family.id).removeValue()
        ref.child("families/\(family.id)/members/\(FIRAuth.auth()?.currentUser?.uid)").removeValue()
        self.tableView.reloadData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeScreen" {
            let viewController  = segue.destination as! FamilyViewController
            viewController.family = family!
        }
    }
    

}
