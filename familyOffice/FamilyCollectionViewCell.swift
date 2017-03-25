//
//  FamilyCollectionViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 19/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class FamilyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
<<<<<<< Updated upstream
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageFamily.image = #imageLiteral(resourceName: "familyImage")
=======
    override func layoutSubviews() {
        super.layoutSubviews()
>>>>>>> Stashed changes
        self.imageFamily.layer.cornerRadius = self.imageFamily.frame.size.width/16
        self.imageFamily.clipsToBounds = true
    }
    

}
