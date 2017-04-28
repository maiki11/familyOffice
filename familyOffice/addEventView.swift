//
//  addEventView.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 26/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
protocol datepickerSelection: class {
    func dateSelected(text: String) -> Void
    func cancel() -> Void
}

class addEventView: UIView{
    var txtfieldselected: Int!
    weak var shareEventDelegate : ShareEvent!
    //OUTLETS
    @IBOutlet weak var dateStartTxtField: UITextField!
    @IBOutlet weak var titleTextField: textFieldStyleController!
    @IBOutlet weak var descriptionTextField: textFieldStyleController!
    @IBOutlet weak var endDateTxtField: UITextField!
    
    let blackView = UIView()
    let xib = Bundle.main.loadNibNamed("datePickerPopOver", owner: self, options: nil)?[0] as! datePickerPopOver

    
    @IBAction func handleEditingDidEndTitle(_ sender: UITextField) {
        
        //Validation Title
        shareEventDelegate.event.title = titleTextField.text
        
    }
    @IBAction func handleEditingDidEndDescription(_ sender: textFieldStyleController) {
        shareEventDelegate.event.description = descriptionTextField.text
    }
    @IBAction func handleTouchDownSDate(_ sender: UITextField) {
        txtfieldselected = 1
        showSetting()
        
    }
    
    @IBAction func handleTouchDownEDate(_ sender: UITextField) {
        txtfieldselected = 2
        showSetting()
    }
    
    func showSetting() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            xib.datepickerSelectionDelegate = self
            xib.frame = self.bounds
            xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            window.addSubview(blackView)
            window.addSubview(xib)
            
            
            let height : CGFloat = 242.0
            let y = window.frame.height/3
            xib.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .layoutSubviews, animations: {
                self.blackView.alpha = 1
                
                self.xib.frame = CGRect(x: 0, y: y, width: self.xib.frame.width, height: self.xib.frame.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.xib.frame = CGRect(x: 0, y:window.frame.height-0, width: self.xib.frame.width, height: self.xib.frame.height)
                
            }
        })
    }

    
}
extension addEventView :  datepickerSelection  {
    func dateSelected(text: String) {
        if txtfieldselected == 1 {
            dateStartTxtField.text = text
            shareEventDelegate.event.date = text
            
        }else{
            endDateTxtField.text = text
            shareEventDelegate.event.endDate = text
        }
        self.handleDismiss()
    }
    func cancel() {
        self.handleDismiss()
    }
}
