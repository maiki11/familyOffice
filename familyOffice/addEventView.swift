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

class addEventView: UIView {
    var txtfieldselected: Int!
    weak var shareEventDelegate : ShareEvent!
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurEffectView = UIVisualEffectView()
    var PickerView: UIPickerView = UIPickerView()
    var pickerData = ["1 minuto antes","10 minutos antes","30 minutos antes","1 hora antes","2 horas antes","1 día antes"]
    var valueDate = [1,10,30,60,120,1440]
    //OUTLETS
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var dateStartTxtField: UITextField!
    @IBOutlet weak var titleTextField: textFieldStyleController!
    @IBOutlet weak var descriptionTextField: textFieldStyleController!
    @IBOutlet weak var endDateTxtField: UITextField!
    override func awakeFromNib() {
        self.PickerView.isHidden = false
        self.PickerView.dataSource = self
        
        self.PickerView.delegate = self
        self.PickerView.backgroundColor = UIColor.clear
    
    }
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        
    }
    @IBAction func handleSelectReminder(_ sender: UIButton) {
      
        if let window = UIApplication.shared.keyWindow {
            blurEffectView.effect = blurEffect
            blurEffectView.frame = window.frame
            blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            PickerView.frame = self.bounds
            
            window.addSubview(blurEffectView)
            window.addSubview(self.PickerView)
            self.blurEffectView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .layoutSubviews, animations: {
                self.blurEffectView.alpha = 1
                self.PickerView.frame = window.frame
            }, completion: nil)
        }

    }
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
    @IBAction func handleChangeEndDate(_ sender: UITextField) {
        txtfieldselected = 2
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
            self.blurEffectView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.xib.frame = CGRect(x: 0, y:window.frame.height-0, width: self.xib.frame.width, height: self.xib.frame.height)
                self.PickerView.frame = CGRect(x: 0, y:window.frame.height-0, width: self.xib.frame.width, height: self.xib.frame.height)
            }
        })
    }

    
}
extension addEventView : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "System", size: 30.0)
        label.text = pickerData[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reminderButton.setTitle(pickerData[row],for: .normal)
        shareEventDelegate.event.reminder = Date(string:  shareEventDelegate.event.date, formatter: .InternationalFormat)?.addingTimeInterval(TimeInterval(valueDate[row] * 60 * -1)).string(with: .InternationalFormat)
        handleDismiss()
    }
    
}
extension addEventView :  datepickerSelection  {
    func dateSelected(text: String) {
        if txtfieldselected == 1 {
            dateStartTxtField.text = text
            shareEventDelegate.event.date = text
            
        }else{
            if !verifyEndDate(text) {
                endDateTxtField.removeAttribute()
                endDateTxtField.text = text
                shareEventDelegate.event.endDate = text
            }else{
                shareEventDelegate.event.endDate = ""
            }
        }
        self.handleDismiss()
    }
    func cancel() {
        self.handleDismiss()
    }
    func verifyEndDate(_ endDate: String) -> Bool {
        if Date(string: shareEventDelegate.event.date, formatter: .InternationalFormat)! >  Date(string: endDate, formatter: .InternationalFormat)!{
            endDateTxtField.text = endDate
            endDateTxtField.strikeText()
            return true
        }else{
            return false
        }
    }
}
