//
//  MemberCollectionViewCell.swift
//  familyOffice
//
//  Created by Nan Montaño on 05/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class HealthMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var selectedMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.layer.cornerRadius = self.image.frame.width/2
        self.image.clipsToBounds = true
        selectedMember.layer.cornerRadius = selectedMember.frame.width/2
        selectedMember.clipsToBounds = true
    }
    
}
