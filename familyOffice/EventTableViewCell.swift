//
//  EventTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewEvent: UITableView!
    var delegate :UICollectionViewDelegate!
    var dataSource : UICollectionViewDataSource!
    var info: DateModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setTableViewDataSourceDelegate
        <D: UITableViewDataSource & UITableViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        tableViewEvent.delegate = dataSourceDelegate
        tableViewEvent.dataSource = dataSourceDelegate
        tableViewEvent.tag = row
        tableViewEvent.reloadData()
    
    }
    func setCollectionDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        delegate = dataSourceDelegate
        dataSource = dataSourceDelegate
    }


}

extension EventTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let collectionViewCell = cell as? GuestMembersTableViewCell else { return }
        collectionViewCell.setCollectionViewDataSourceDelegate(dataSource: dataSource, delegate: delegate, forRow: indexPath.row)
    }
}
