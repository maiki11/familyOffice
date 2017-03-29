//
//  chatCellTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 24/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class chatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var haveMessage: UIView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.userImage.clipsToBounds = true
        self.haveMessage.layer.cornerRadius = 25/2
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderWidth = 2.0
        self.userImage.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        self.userImage.layer.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        // Configure the view for the selected state
    }
    
}
