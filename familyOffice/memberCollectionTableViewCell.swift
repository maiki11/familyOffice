//
//  memberCollectionTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 17/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class memberCollectionTableViewCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 100, height: 50)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor =  UIColor.clear
      
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(collectionView)
        addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(UINib(nibName: "MemberInviteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellMember")
        collectionView.register(UINib(nibName: "headerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Constants.Services.USER_SERVICE.users.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMember", for: indexPath) as! MemberInviteCollectionViewCell
        
        if Constants.Services.USER_SERVICE.users.count > 1 {
            cell.bind(userModel: Constants.Services.USER_SERVICE.users[indexPath.row+1], filter: "blackwhite")
        }
        
        // Configure the cell
        
        return cell
    }
    
}

extension memberCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! headerCollectionReusableView
        headerView.titleLabel.text = "Invitar a personas: "
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MemberInviteCollectionViewCell
        cell.check.isHidden = !cell.check.isHidden
        if !cell.check.isHidden {
            cell.profileImage.loadImage(urlString: (cell.userModel?.photoURL)!)
        }else{
            cell.profileImage.blackwhite()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
 
   
}
