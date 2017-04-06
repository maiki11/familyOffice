//
//  EventTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    var delegate :UICollectionViewDelegate!
    var dataSource : UICollectionViewDataSource!
    var info: DateModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        count.layer.cornerRadius = count.frame.width/2
        count.clipsToBounds = true
        // Configure the view for the selected state
    }
    func configure(date: DateModel) {
        self.info = date
        self.hour.text = Date(string: date.date, formatter: .dayMonthYearHourMinute)?.string(with: .localeMediumStyle)
        self.title.text = date.title
    }
    func  setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    
    }
   
}
