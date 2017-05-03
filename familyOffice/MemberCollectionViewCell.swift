//
//  MemberCollectionViewCell.swift
//  familyOffice
//
<<<<<<< HEAD
//  Created by Leonardo Durazo on 30/03/17.
=======
//  Created by Nan Montaño on 05/abr/17.
>>>>>>> nancio
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
<<<<<<< HEAD
    override func awakeFromNib() {
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
    }
=======
    @IBOutlet weak var selectedMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.layer.cornerRadius = self.image.frame.width/2
        self.image.clipsToBounds = true
        
        selectedMember.layer.cornerRadius = selectedMember.frame.width/2
        selectedMember.clipsToBounds = true
        selectedMember.alpha = 0
    }
    
>>>>>>> nancio
}
