//
//  ModuleCollectionViewCell.swift
//  familyOffice
//
//  Created by miguel reina on 23/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
class ModuleCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var container: UIImageView!
    @IBOutlet weak var buttonicon: MIBadgeButton!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.container.layer.borderWidth = 1
        self.container.layer.borderColor = UIColor.black.cgColor
        self.container.layer.cornerRadius = 3
        self.container.clipsToBounds = true
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        
    }
    
}
