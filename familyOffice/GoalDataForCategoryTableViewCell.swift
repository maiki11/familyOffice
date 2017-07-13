//
//  GoalDataForCategoryTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 12/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class GoalDataForCategoryTableViewCell: UITableViewCell, GoalBindable {
    var goal: Goal!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
