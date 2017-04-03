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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates[collectionView.tag].members.count
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if dates[collectionView.tag].members.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 36, height: 273)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        
        if !dates[collectionView.tag].members[indexPath.row].isEmpty {
            let id = dates[collectionView.tag].members[indexPath.row]
            if let user = USER_SERVICE.users.filter({$0.id == id}).first {
                if !user.photoURL.isEmpty {
                    cell.image.image = #imageLiteral(resourceName: "profile_default")
                    cell.image.loadImage(urlString: user.photoURL)
                }
            }else{
                REF_SERVICE.valueSingleton(ref: "users/\(id)")
            }
        }
        return cell
    }
}
