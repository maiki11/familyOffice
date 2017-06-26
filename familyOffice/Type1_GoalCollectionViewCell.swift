//
//  Type1_GoalCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class Type1_GoalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priorityLbl: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photo.layer.cornerRadius = photo.frame.width/2
    }

}
