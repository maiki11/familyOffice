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
    
    
    var userIndex : Int = 0
    var observers : [NSObjectProtocol] = []
    
    var diseasesUrl : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        if userIndex == 0 {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(button:)))
            self.navigationItem.rightBarButtonItem = addButton
        }
    	
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        var user = USER_SERVICE.users[userIndex]
        diseasesUrl = "users/\(user.id!)/health/diseases"
        REF_SERVICE.chilAdded(ref: diseasesUrl)
        REF_SERVICE.chilRemoved(ref: diseasesUrl)
        REF_SERVICE.childChanged(ref: diseasesUrl)
        
        var observerJustAdded = true
        
        let addedObs = NotificationCenter.default
            .addObserver(forName: HEALTHDISEASE_ADDED, object: nil, queue: nil) { disease in
                if observerJustAdded {
                    observerJustAdded = false
                    user.health.diseases.removeAll()
                    user.health.diseases.append(disease.object as! Health.Disease)
                    USER_SERVICE.users[self.userIndex] = user
                }
            	self.tableView.reloadData()
        	}
        
        let updatedObs = NotificationCenter.default
            .addObserver(forName: HEALTHDISEASE_UPDATED, object: nil, queue: nil, using: { _ in
            	self.tableView.reloadData()
        	})
        
        let removedObs = NotificationCenter.default
            .addObserver(forName: HEALTHDISEASE_REMOVED, object: nil, queue: nil, using: { _ in
				self.tableView.reloadData()
        	})
        
        observers.append(addedObs)
        observers.append(updatedObs)
        observers.append(removedObs)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        REF_SERVICE.remove(ref: diseasesUrl)
        
        observers.forEach({proto in
            NotificationCenter.default.removeObserver(proto)
        })
        observers.removeAll()
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
        return USER_SERVICE.users[userIndex].health.diseases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = USER_SERVICE.users[userIndex].health.diseases[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return userIndex == 0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let disease = USER_SERVICE.users[userIndex].health.diseases[indexPath.row]
        let editAction = UITableViewRowAction(style: .normal, title: "Editar", handler: {_ in
            let alert = UIAlertController(title: "Editar \(disease.name)", message: "Cambiar nombre", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                let dname = alert.textFields?[0].text
                USER_SERVICE.users[self.userIndex].health.diseases[indexPath.row].name = dname!
                USER_SERVICE.updateUser(user: USER_SERVICE.users[self.userIndex])
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        })
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Quitar", handler: {_ in
            let alert = UIAlertController(title: "Quitar \(disease.name)", message: "Quitar \(disease) de sus enfermedades", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                
                USER_SERVICE.users[self.userIndex].health.diseases.remove(at: indexPath.row)
                USER_SERVICE.updateUser(user: USER_SERVICE.users[self.userIndex])
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
            
            let dname = alert.textFields?[0].text
            USER_SERVICE.users[self.userIndex].health.diseases.append(Health.Disease(name: dname!))
            USER_SERVICE.updateUser(user: USER_SERVICE.users[self.userIndex])
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
