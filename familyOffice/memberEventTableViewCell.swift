//
//  memberEventTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 31/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class memberEventTableViewCell: UITableViewCell, UserModelBindable {
    var userModel: User?
    var filter: String!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
