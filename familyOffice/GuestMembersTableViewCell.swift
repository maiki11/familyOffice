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
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: USERS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let user : User = obj.object as? User {
                self.addMember(id: user.id)
            }
        })
    }
    func addMember(id: String) -> User {
        if let user = USER_SERVICE.users.filter({$0.id == id}).first {
            if !USER_SERVICE.users.contains(where: {$0.id == id}){
                REF_SERVICE.childChanged(ref: "users/\(id)")
                self.membersTable.insertRows(at: [NSIndexPath(row: self.members.count-1, section: 0) as IndexPath], with: .fade)
            }
            //self.addMembers(user: user)
        }else{
            REF_SERVICE.valueSingleton(ref: "users/\(id)")
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testDate[collectionView.tag].members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return 
    }
}
