//
//  FamilyCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 19/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class FamilyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageFamily.layer.cornerRadius = self.imageFamily.frame.size.width/16
        self.imageFamily.clipsToBounds = true
    }
}
