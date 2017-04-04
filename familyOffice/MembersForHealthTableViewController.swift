//
//  MembersForHealthTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 03/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MembersForHealthTableViewController: UITableViewController {
    
    var fam : Family!
    var membersIds : [String] = []
    var observer : NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let user = USER_SERVICE.users[0]
        fam = FAMILY_SERVICE.families.first(where: {$0.id == user.familyActive})
        membersIds = fam?.members?.allKeys as! [String]
        let myId = membersIds.index(where: { $0 == user.id! })
        membersIds.remove(at: myId!)
        
        for id in membersIds {
            USER_SERVICE.getUser(uid: id)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observer = NotificationCenter.default
            .addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil, using: { _ in
                self.tableView.reloadData()
            })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(observer!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : membersIds.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Yo"
        } else {
            return "Demás miembros"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Ver/Cambiar mis datos médicos"
        }else{
            if let user = USER_SERVICE.users.first(where: { $0.id == membersIds[indexPath.row] }) {
                cell.textLabel?.text = user.name
            }else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell {
        	let indexPath = tableView.indexPath(for: cell)
            let id = membersIds[indexPath!.row]
            let userIndex = indexPath!.section == 0 ? 0 : USER_SERVICE.users.index(where: {$0.id == id})
            let ctrl = segue.destination as! HealthTableViewController
            ctrl.userIndex = userIndex!
        }else {
            print(sender!)
        }
    }

}
