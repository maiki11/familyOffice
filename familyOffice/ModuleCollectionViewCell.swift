//
//  ModuleCollectionViewCell.swift
//  familyOffice
//
//  Created by miguel reina on 23/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class ModuleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    override func layoutSubviews() {
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 3, height: 3)
        image.layer.shadowOpacity = 0.5
        image.layer.shadowRadius = 10
    }
}
