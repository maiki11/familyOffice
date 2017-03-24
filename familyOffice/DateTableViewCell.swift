//
//  DateTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Hour: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Priority: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Priority.layer.cornerRadius = self.Priority.frame.size.width/2
        Priority.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
