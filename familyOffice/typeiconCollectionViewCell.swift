//
//  typeiconCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class typeiconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialize your code here
        self.checkimage.layer.borderWidth = 1
        self.checkimage.layer.borderColor = UIColor.white.cgColor
        
    }
}
