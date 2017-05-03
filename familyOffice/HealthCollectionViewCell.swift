//
//  HealthCollectionViewCell.swift
//  familyOffice
//
//  Created by Nan Montaño on 06/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class HealthTableViewCell: UITableViewCell, ElementBindable {
    var element: Health.Element?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}
