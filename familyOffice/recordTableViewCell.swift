//
//  recordTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 01/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class recordTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photo.layer.cornerRadius = self.photo.frame.size.width/2
        self.photo.clipsToBounds = true
<<<<<<< Updated upstream
        self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width/2
        self.iconImage.clipsToBounds = true
=======
>>>>>>> Stashed changes
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
<<<<<<< Updated upstream
        // Configure the view for the selected state
    }
    
    func config(title: String, date: String) -> Void {
      
        activity.text = title
        self.date.text = date
       
    }
=======
        
        // Configure the view for the selected state
    }
>>>>>>> Stashed changes

}
