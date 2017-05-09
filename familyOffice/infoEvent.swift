//
//  addEvent.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 26/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit


class addEvent: BaseCell {
    let xib = Bundle.main.loadNibNamed("addEvent", owner: self, options: nil)?[0] as! addEventView
    weak var shareEventDelegate : ShareEvent!
    
    override func setupViews() {
        super.setupViews()
        xib.frame = self.bounds
        xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func addView() -> Void {
        xib.shareEventDelegate = shareEventDelegate
        self.addSubview(xib)
        xib.dateStartTxtField.text = shareEventDelegate.event.date
        xib.endDateTxtField.text = shareEventDelegate.event.endDate
        xib.descriptionTextField.text = shareEventDelegate.event.description
        xib.titleTextField.text = shareEventDelegate.event.title
    }
  
    

}
