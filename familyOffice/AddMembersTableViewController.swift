//
//  AddMembersTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class AddMembersTableViewController: UITableViewController {
    
    var contacts : [CNContact] = []
    var selected : [User] = []
    var users : [User] = []
    var family : Family!
    var itemCount = 0
    let IndexPathOfFirstRow = NSIndexPath(row: 0, section: 0)
    var firstCell : SelectedTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(save(sender:)))
        self.navigationItem.rightBarButtonItem = doneButton
        
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
        if section == 0 {
            return 1
        }else{
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SelectedTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        firstCell = tableViewCell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getContacts()
        showContacts()
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        users = []
        selected = []
        super.viewDidDisappear(animated)
        REF_USERS.removeAllObservers()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell for selected members
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedMembers", for: indexPath) as! SelectedTableViewCell
            return cell
        }
        
        //Conctacts
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyMemberTableViewCell
        
        if !user.photoURL.isEmpty {
            cell.memberImage.loadImage(urlString: user.photoURL)
        }
        cell.name.text = user.name
        cell.phone.text = user.phone
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if selected.count == 0 {
                return 0.0
            }
            return 100.0
        }
        return 84.0
    }
    func getContacts() -> Void {
        let store = CNContactStore()
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])
        try! store.enumerateContacts(with: fetchRequest) { contact, stop in
            if contact.phoneNumbers.count > 0 {
                self.contacts.append(contact)
            }
        }
    }
    func showContacts() -> Void {
        self.users = []
        for item in contacts {
            for phone in item.phoneNumbers {
                if let user = USER_SERVICE.users.filter({ $0.phone == phone.value.value(forKey: "digits") as! String }).first {
                    if (FAMILY_SERVICE.families.first(where: {$0.id == family.id})?.members?[user.id]) == nil {
                        self.users.append(user)
                        self.tableView.reloadData()
                    }
                }else{
                    USER_SERVICE.getUser(phone: (phone.value.value(forKey: "digits"))! as! String)
                }
            }
        }
        NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){user in
            self.showContacts()
        }
    }
    func save(sender: UIBarButtonItem) -> Void {
        for user in selected {
            FAMILY_SERVICE.addMember(member: user.id, family: family.id)
        }
        
    }
    
}
