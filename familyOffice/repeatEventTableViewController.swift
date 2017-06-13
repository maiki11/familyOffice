//
//  repeatEventTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class repeatEventTableViewController: UITableViewController {
    weak var shareEvent: ShareEvent!
    var select : String! = "Nunca"
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        let quitButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.cancel))
        
        navigationItem.rightBarButtonItems = [addButton,quitButton]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissPopover() {
        _ = navigationController?.popViewController(animated: true)    }
    
    func save() -> Void {
        shareEvent?.event.repeatmodel.each = select
        dismissPopover()
        
    }
    func cancel() -> Void {
        dismissPopover()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            select = cell.textLabel?.text
            cell.accessoryType = .checkmark
        }
    }
    
    
    
}
