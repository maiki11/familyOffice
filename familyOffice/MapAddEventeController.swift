//
//  MapAddEventeController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 10/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MapAddEventTable: BaseCell, UITableViewDelegate, UITableViewDataSource  {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(tableView)
        addContraintWithFormat(format: "H:|[v0]|", views: tableView)
        addContraintWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
           
            return self.frame.height/3
        }
        return self.frame.height/3 * 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MapTableViewCell
        return cell
        
    }


    
    
}
