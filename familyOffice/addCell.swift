//
//  addCell.swift
//  familyOffice
//
//  Created by miguel reina on 03/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class addCell: UICollectionViewCell {
    
    @IBOutlet weak var addView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addView.layer.borderWidth = 1.0
        self.addView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        self.addView.layer.cornerRadius = 5
    }
}
