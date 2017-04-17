//
//  GuestMembersTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func viewWillAppear(_ animated: Bool) {
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.USER_NOTIFICATION, object: nil, queue: nil){ obj in
            self.tableView.reloadData()
        })
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cant: Int! = dates[collectionView.tag].members.count
        return cant > 0 ? cant < 5 ? cant : 5 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cant: Int! = dates[collectionView.tag].members.count
        if cant == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nomemberCell", for: indexPath)
            return cell
        }else if indexPath.item < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
            cell.image.image = #imageLiteral(resourceName: "profile_default")
            let id: String = dates[collectionView.tag].members[indexPath.item]
            if !id.isEmpty {
                if let user = Constants.Services.USER_SERVICE.users.filter({$0.id == id}).first {
                    if !user.photoURL.isEmpty {
                        cell.image.loadImage(urlString: user.photoURL)
                    }
                }else{
                    Constants.Services.REF_SERVICE.valueSingleton(ref: "users/\(id)")
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
            cell.image.image = #imageLiteral(resourceName: "more_icon")
            cell.image.tintColor = UIColor.gray
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.cornerRadius = cell.frame.width/2
            cell.clipsToBounds = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cant: Int! = dates[collectionView.tag].members.count
        if cant == 0 {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize(width: 30, height: 30)
    }
   

    
    
    
}
