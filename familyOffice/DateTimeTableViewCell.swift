//
//  DateTimeTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class DateTimeTableViewCell: UITableViewCell {
    
    var addEventClass: AddEventTableViewController!
    
    @IBOutlet weak var dateTime: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func handleChange(_ sender: UIDatePicker) {
        if addEventClass != nil {
            addEventClass.setDateValue(date: String(describing: sender.date))
        }
    }
    
}
