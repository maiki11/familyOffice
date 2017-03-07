//
//  memberSelectedCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class memberSelectedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMember: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageMember.image = #imageLiteral(resourceName: "profile_default")
        self.imageMember.layer.cornerRadius = self.imageMember.frame.size.width/2
        self.imageMember.clipsToBounds = true
    }
   
}
