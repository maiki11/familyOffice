//
//  GoalDataofSectionTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 12/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class GoalDataofSectionTableViewCell: UITableViewCell {
    var data = [Goal]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setTableViewDataSourceDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func  setTableViewDataSourceDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = self.tag
        tableView.reloadData()
        
    }
    func chageHeight() -> Void {
        tableviewHeight.constant = CGFloat(data.count * 44)
    }

}
extension GoalDataofSectionTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalDataForCategoryTableViewCell
        cell.bind(goal: data[indexPath.row])

        return cell
    }
    
}
