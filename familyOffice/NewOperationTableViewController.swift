//
//  NewOperationTableViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 24/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class NewOperationTableViewController: UITableViewController {

    
    @IBOutlet weak var operationDescriptionText: UITextView!
    @IBOutlet weak var operationDatePicker: UIDatePicker!
    
    var editOperation : Health.Operation?
    var editIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        operationDatePicker.maximumDate = Date()
        
        let saveButton = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        if let op = editOperation {
            operationDescriptionText.text = op.description
            operationDatePicker.date = op.date
        }
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
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save(sender: UIBarButtonItem){
        let desc = operationDescriptionText.text
        let date = operationDatePicker.date
        
        var user = USER_SERVICE.users[0]
        var health = Health(health: user.health ?? [:])
        
        if desc == nil || desc?.characters.count == 0 {
            ANIMATIONS.shakeTextField(txt: operationDescriptionText)
        }else if var op = editOperation {
            op.description = desc!
            op.date = date
            
            health.operations[editIndex!] = op.toDictionary()
            user.health = health.toDictionary()
            USER_SERVICE.updateUser(user: user)
            
            self.navigationController!.popViewController(animated: true)

        } else {
            let op = Health.Operation(description: desc!, date: date)
            
            health.operations.append(op.toDictionary())
            user.health = health.toDictionary()
            USER_SERVICE.updateUser(user: user)
            
            self.navigationController!.popViewController(animated: true)
        }
    }

}
