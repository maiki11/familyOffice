//
//  ToDoItemCell.swift
//  familyOffice
//
//  Created by Ernesto Salazar on 7/3/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import M13Checkbox

class ToDoItemCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var checkFinished: M13Checkbox!
    @IBOutlet var countLabel: UILabel!
    
}
