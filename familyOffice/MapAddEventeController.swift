//
//  MapAddEventeController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 10/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit


class MapAddEventTable: BaseCell, UITableViewDelegate, UITableViewDataSource  {
   
    weak var shareEventDelegate : ShareEvent!
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(tableView)
        
        addContraintWithFormat(format: "H:|[v0]|", views: tableView)
        addContraintWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: "mapCellId")
        tableView.register(UINib(nibName: "memberCollectionTableViewCell", bundle: nil),forCellReuseIdentifier: "cellId2")
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height/2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCellId", for: indexPath) as! MapTableViewCell
            cell.shareEventDelegate = shareEventDelegate
            cell.setupLocation()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as! memberCollectionTableViewCell
            cell.shareEventDelegate = shareEventDelegate
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.willAppear()
            return cell
        }
        
        
    }


    
    
}
