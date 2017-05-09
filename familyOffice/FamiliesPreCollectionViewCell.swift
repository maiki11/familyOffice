//
//  FamiliesPreCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 15/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class FamiliesPreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.image = #imageLiteral(resourceName: "familyImage")
        self.image.layer.cornerRadius = 5
        self.image.clipsToBounds = true
    }
}
