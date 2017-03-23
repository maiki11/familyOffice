//
//  DiseasesTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 22/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class DiseasesTableViewController: UITableViewController {
    
    var diseasesRef: FIRDatabaseReference!
    var observerId: UInt!
    var diseases: [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = USER_SERVICE.users[0]
        diseasesRef = REF_USERS.child("\(user.id!)/health/diseases")
        print(diseasesRef.url)
//        if let health = user.health {
//            diseases = health[Health.kHealthDiseases] as? [String] ?? []
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(button:)))
        self.navigationItem.rightBarButtonItem = addButton
    	
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        observerId = diseasesRef.observe(.value, with: {snapshot in
            print(snapshot.value!)
            self.diseases = snapshot.value as? [String] ?? []
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    	diseasesRef.removeObserver(withHandle: observerId)
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
        return diseases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = diseases[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var user = USER_SERVICE.users[0]
        let health = user.health ?? [:]
        let disease = diseases[indexPath.row]
        let editAction = UITableViewRowAction(style: .normal, title: "Editar", handler: {_ in
            let alert = UIAlertController(title: "Editar \(disease)", message: "Cambiar nombre", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                var diseases = health[Health.kHealthDiseases] as? [String] ?? []
                
                let dname = alert.textFields?[0].text
                diseases[indexPath.row] = dname!
                health.setValue(diseases, forKey: Health.kHealthDiseases)
                user.health = health
                USER_SERVICE.updateUser(user: user)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        })
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Quitar", handler: {_ in
            let alert = UIAlertController(title: "Quitar enfermedad", message: "Quitar \(disease) de sus enfermedades", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                var diseases = health[Health.kHealthDiseases] as? [String] ?? []
                
                diseases.remove(at: indexPath.row)
                health.setValue(diseases, forKey: Health.kHealthDiseases)
                user.health = health
                USER_SERVICE.updateUser(user: user)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        })
        return [editAction, deleteAction]
    }
    

//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//

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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
    func add(button: UIBarButtonItem){
        
        let alert = UIAlertController(title: "Añadir enfermedad", message: "Nombre de la enfermedad", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
        	var user = USER_SERVICE.users[0]
            let health = user.health ?? [:]
            var diseases = health[Health.kHealthDiseases] as? [String] ?? []
            
            let dname = alert.textFields?[0].text
            diseases.append(dname!)
            health.setValue(diseases, forKey: Health.kHealthDiseases)
            user.health = health
            USER_SERVICE.updateUser(user: user)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
