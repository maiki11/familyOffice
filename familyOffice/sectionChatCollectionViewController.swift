//
//  ChatTableViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ChatTableViewController: BaseCell, UITableViewDelegate, UITableViewDataSource {
    
    
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
        tableView.register(chatCell.self, forCellReuseIdentifier: "cellId")
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! chatCell
        let colors :
            [UIColor] = [UIColor.black, UIColor.blue, UIColor.cyan]
        cell.backgroundColor = colors[indexPath.row]
        // Configure the cell..
        return cell
    }
    
}

class chatCell: UITableViewCell {
    let label: UILabel = {
        let lb = UILabel()
        lb.font = lb.font.withSize(12)
        lb.tintColor = UIColor.init(red: 91, green: 14, blue: 13, alpha: 0)
        return lb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(label)
        addContraintWithFormat(format: "H:[v0(60)]", views: label)
        addContraintWithFormat(format: "V:[v0(28)]", views: label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    
}
