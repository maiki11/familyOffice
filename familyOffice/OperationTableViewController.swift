//
//  OperationTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 24/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class OperationTableViewController: UITableViewController {
    
    var operationsRef : FIRDatabaseReference!
    var observerId : UInt?
    
    var operations : [Health.Operation] = []
    
    var operationToEdit: Health.Operation?
    var indexToEdit: Int?
    
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = USER_SERVICE.users[0]
        operationsRef = REF_USERS.child("\(user.id!)/\(User.kUserHealthKey)/\(Health.kHealthOperations)")

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "es_MX")
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        operationsRef.observe(.value, with: {snapshot in
        	self.operations = []
            let iter = snapshot.children
            while let op = iter.nextObject() as? FIRDataSnapshot {
                self.operations.append(Health.Operation(snapshot: op))
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return operations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let op = operations[indexPath.row]
        cell.textLabel!.text = op.description
        
        cell.detailTextLabel!.text = dateFormatter.string(from: op.date)
        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let op = operations[indexPath.row]
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar", handler: {_ in
        	self.operationToEdit = op
            self.indexToEdit = indexPath.row
            self.performSegue(withIdentifier: "addOperation", sender: self)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar", handler: {_ in
        	let alert = UIAlertController(title: "Operación del día \(self.dateFormatter.string(from: op.date))", message: "¿Desea eliminar?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: {_ in
            	var user = USER_SERVICE.users[0]
                var health = Health(health: user.health ?? [:])
                
                health.operations.remove(at: indexPath.row)
                user.health = health.toDictionary()
                
                USER_SERVICE.updateUser(user: user)
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        })
        
        return [editAction, deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.operationToEdit = operations[indexPath.row]
        self.indexToEdit = indexPath.row
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
        let ctrl = segue.destination as! NewOperationTableViewController
        ctrl.editOperation = operationToEdit
        ctrl.editIndex = indexToEdit
        
        operationToEdit = nil
        indexToEdit = nil
    }
 
    
    func add(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addOperation", sender: self)
    }


}
