//
//  ContactsViewController.swift
//  familyOffice
//
//  Created by miguel reina on 26/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

class contactTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
        navigationItem.rightBarButtonItem = addButton
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    func add(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addContactSegue", sender: self)
    }
    
}
