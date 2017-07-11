//
//  addContactTableViewController.swift
//  familyOffice
//
//  Created by miguel reina on 27/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class addContactTableViewController: UITableViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var job: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //configuration()
        tableView.reloadData()
    }
    
    func configuration(){
        
    }
    
    func save(sender: UIBarButtonItem) {
        let key = Constants.FirDatabase.REF.child("contacts").childByAutoId().key
        let contact: Contact! = Contact(name: self.name.text!, phone: self.phone.text!, job: self.job.text!, id:key)
        self.insertContact(contact: contact, key: key)
    }
    
    func insertContact(contact: Contact, key: String) {
        let ref = "contacts/\(service.USER_SERVICE.users[0].familyActive!)/\(key)"
        service.FAMILY_SERVICE.insert(ref, value: contact.toDictionary(), callback: { (response) in})
    }
    
}
