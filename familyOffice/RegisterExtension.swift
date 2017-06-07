//
//  RegisterExtension.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 25/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

extension RegisterFamilyViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        users = []
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        let mainQueue = OperationQueue.main
        self.localeChangeObserver =  center.addObserver(forName: notCenter.USER_NOTIFICATION, object: nil, queue: mainQueue){user in
            if let user : User = user.object as? User {
                self.addMember(phone: user.phone)
            }
        }
        getContacts()
        showContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Conctacts
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyMemberTableViewCell
        cell.memberImage.image = #imageLiteral(resourceName: "profile_default")
        if !user.photoURL.isEmpty {
            cell.memberImage.loadImage(urlString: user.photoURL)
        }
        cell.name.text = user.name
        cell.phone.text = user.phone
        
        return cell
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
                if phone.value.value(forKey: "digits") as? String  != service.USER_SERVICE.users[0].phone{
                    self.addMember(phone: phone.value.value(forKey: "digits") as! String )
                }
                
            }
        }
    }
    func addMember(phone: String) -> Void {
        
        if let user = service.USER_SERVICE.users.filter({$0.phone == phone}).first {
            if !self.users.contains(where: {$0.id == user.id}) {
                self.users.append(user)
                self.tableView.insertRows(at: [NSIndexPath(row: self.users.count-1, section: 0) as IndexPath], with: .fade)
            }
        }else{
            service.USER_SERVICE.getUser(phone: phone)
        }
    }
}

extension RegisterFamilyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return selected.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMember", for: indexPath) as! memberSelectedCollectionViewCell
        
        let user = selected[indexPath.row]
        cell.imageMember.image = #imageLiteral(resourceName: "profile_default")
        if !user.photoURL.isEmpty{
            cell.imageMember.loadImage(urlString: user.photoURL)
        }
        cell.name.text = user.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: IndexPath(row: users.index(where: {$0.id == selected[indexPath.row].id})!, section: 0), animated: true)
        selected.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selUser = users[indexPath.row]
        if !selected.contains(where: {$0.id == selUser.id}) {
            selected.append(selUser)
            self.collectionView.insertItems(at: [IndexPath(item: selected.count-1, section: 0)])
           
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selUser = users[indexPath.row]
        let index = IndexPath(item: selected.index(where: {$0.id == selUser.id})!, section: 0)
        selected.remove(at: selected.index(where: {$0.id == selUser.id})!)
        self.collectionView.deleteItems(at: [index])
    }
   
    
}
