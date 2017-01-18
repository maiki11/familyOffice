//
//  FamilyTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 16/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var members: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageFamily.layer.cornerRadius = self.imageFamily.frame.size.width/2
        self.imageFamily.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}