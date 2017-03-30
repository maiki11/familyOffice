//
//  GuestMembersTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class GuestMembersTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionViewDataSourceDelegate
        (dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, forRow row: Int) {
        
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = row
        collectionView.reloadData()
    }

}
