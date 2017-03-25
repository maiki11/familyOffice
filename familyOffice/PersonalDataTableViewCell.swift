//
//  PersonalDataTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class PersonalDataTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
<<<<<<< Updated upstream
    func configure(text: String?, placeholder: String ) -> Void {
        
        myTextField.text = text
        myTextField.placeholder = placeholder
=======
    func configure(text: String?, placeholde: String ) -> Void {
        
        myTextField.text = text
        myTextField.placeholder = placeholde
>>>>>>> Stashed changes
    }
   
}
