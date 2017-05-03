//
//  HealthOmniViewController_Categories.swift
//  familyOffice
//
//  Created by Nan Montaño on 07/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

extension HealthOmniViewController : UITableViewDelegate, UITableViewDataSource {
    
    func initElements(){
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.layer.cornerRadius = 2
        
        categoryButtons.forEach({button in
            button.setTitleColor(UIColor.purple, for: .disabled)
        })
        categoryButtons[categorySelected].isEnabled = false
        
        elems = USER_SERVICE.users[userIndex].health.elements.filter({
            $0.type == categorySelected
        })
    }
    
    @IBAction func categoryClick(_ sender: UIButton) {
        let index = categoryButtons.index(of: sender)
        let selectedButton = categoryButtons[categorySelected]
        
        selectedButton.isEnabled = true
        sender.isEnabled = false
        
        categorySelected = index!
        elems = USER_SERVICE.users[userIndex].health.elements.filter({
            $0.type == categorySelected
        })
        categoryTableView.reloadData()
        

    }
    
    func elementsWillAppear(){
        
        categoryTableView.reloadData()
        
        let user = USER_SERVICE.users[userIndex]
        let url = "users/\(user.id!)/health"
        
        REF_SERVICE.chilAdded(ref: url)
        REF_SERVICE.childChanged(ref: url)
        REF_SERVICE.chilRemoved(ref: url)
        
        elementAddedObserver = NotificationCenter.default
            .addObserver(forName: HEALTHELEMENT_ADDED, object: nil, queue: nil, using: {noti in
                if let elem = noti.object as? Health.Element, elem.type == self.categorySelected {
                    self.elems = USER_SERVICE.users[self.userIndex].health.elements.filter({
                        $0.type == self.categorySelected
                    })
                }
        		self.categoryTableView.reloadData()
        	})
        
        elementUpdatedObserver = NotificationCenter.default
            .addObserver(forName: HEALTHELEMENT_UPDATED, object: nil, queue: nil, using: {noti in
                if let elem = noti.object as? Health.Element, elem.type == self.categorySelected {
                    self.elems = USER_SERVICE.users[self.userIndex].health.elements.filter({
                        $0.type == self.categorySelected
                    })
                }
                self.categoryTableView.reloadData()
            })
        
        elementDeletedObserver = NotificationCenter.default
            .addObserver(forName: HEALTHELEMENT_REMOVED, object: nil, queue: nil, using: {noti in
                if let elem = noti.object as? Health.Element, elem.type == self.categorySelected {
                    self.elems = USER_SERVICE.users[self.userIndex].health.elements.filter({
                        $0.type == self.categorySelected
                    })
                }
                self.categoryTableView.reloadData()
            })
    }
    
    func elementsWillDisappear(){
        NotificationCenter.default.removeObserver(elementAddedObserver!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = categoryTableView.dequeueReusableCell(withIdentifier: "Cell") as! HealthTableViewCell
        let elem = elems[indexPath.row]
        cell.bindElement(element: elem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return userIndex == 0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .normal, title: "Editar", handler: { _ in
            var count = -1
            let elemIndex = USER_SERVICE.users[0].health.elements.index(where: { e in
                if e.type == self.categorySelected {
                    count += 1
                }
                return count == indexPath.row
            })
            if let index = elemIndex {
                self.performSegue(withIdentifier: "segueEdit", sender: index)
            }
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar", handler: { _ in
        	let alert = UIAlertController(title: "Eliminar", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {_ in
            	var user = USER_SERVICE.users[self.userIndex]
                user.health.elements.remove(at: indexPath.row)
                USER_SERVICE.updateUser(user: user)
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        return [editAction, deleteAction]
    }

}
