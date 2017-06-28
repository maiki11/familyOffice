//
//  GalleryCollectionViewCell.swift
//  familyOffice
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Image: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.Image.frame.size.width = self.bounds.size.width
        self.Image.frame.size.height = self.bounds.size.height
        self.Title.frame.size.width = self.bounds.size.width
        //self.Image.loadImage(urlString: service.USER_SERVICE.users[0].photoURL)
    }
}
