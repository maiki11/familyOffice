//
//  GuestMembersTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func viewWillAppear(_ animated: Bool) {
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil){ obj in
            self.tableView.reloadData()
        })
    }
    func addMember(id: String, indexPath: IndexPath, collectionView: UICollectionView) -> Void {
        if let user = USER_SERVICE.users.filter({$0.id == id}).first {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
            if !user.photoURL.isEmpty {
                cell.image.loadImage(urlString: user.photoURL)
                cell.image.image = #imageLiteral(resourceName: "familyImage")
            }
        }else{
            REF_SERVICE.valueSingleton(ref: "users/\(id)")
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates[collectionView.tag].members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        cell.image.image = #imageLiteral(resourceName: "profile_default")
        if !dates[collectionView.tag].members[indexPath.row].isEmpty {
            addMember(id: dates[collectionView.tag].members[indexPath.row], indexPath: indexPath, collectionView: collectionView)
            
        }
        return cell
    }
}
