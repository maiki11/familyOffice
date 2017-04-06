//
//  Type2TableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class Type2TableViewCell: UITableViewCell {


    @IBOutlet weak var textLabelText: UILabel!
    @IBOutlet weak var textLabelSelect: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
