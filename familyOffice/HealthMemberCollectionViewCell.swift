//
//  MemberCollectionViewCell.swift
//  familyOffice
//
//  Created by Nan Montaño on 05/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class HealthMemberCollectionViewCell: UICollectionViewCell, UserModelBindable {
    var filter: String!

    var userModel: User?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectedMember: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        self.profileImage.clipsToBounds = true
        selectedMember.layer.cornerRadius = selectedMember.frame.width/2
        selectedMember.clipsToBounds = true
    }
    
}
