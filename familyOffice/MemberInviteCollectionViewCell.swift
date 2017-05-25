//
//  MemberInviteCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 10/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class MemberInviteCollectionViewCell: UICollectionViewCell, UserModelBindable {
    var filter: String!
    var userModel: User?

    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        check.layer.cornerRadius = self.check.frame.size.width / 2
        check.clipsToBounds = true
        // Initialization code
    }
  
    
   
}
