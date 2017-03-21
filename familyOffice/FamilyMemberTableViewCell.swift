//
//  FamilyMemberTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 17/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var adminlabel: UILabel!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.memberImage.image = #imageLiteral(resourceName: "profile_default")
        self.memberImage.layer.cornerRadius = self.memberImage.frame.size.width/2
        self.memberImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
