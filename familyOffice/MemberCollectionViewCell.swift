//
//  MemberCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
    }
}
