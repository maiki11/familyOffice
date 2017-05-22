//
//  datePickerPopOver.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 26/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class datePickerPopOver: UIView {
    weak var datepickerSelectionDelegate : datepickerSelection!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func handleSelect(_ sender: UIButton) {
        let date =  datepicker.date.string(with: .InternationalFormat)
        datepickerSelectionDelegate.dateSelected(text:  date)
    }
 
    @IBAction func handleCancel(_ sender: UIButton) {
        datepickerSelectionDelegate.cancel()
    }

}
