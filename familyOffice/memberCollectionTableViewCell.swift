//
//  memberCollectionTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 17/04/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class memberCollectionTableViewCell: UITableViewCell {
    var userNotification: NSObjectProtocol!
    weak var shareEventDelegate : ShareEvent!
    
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
        
        for item in Constants.Services.FAMILY_SERVICE.families {
            for uid in item.members! {
                if uid == Constants.Services.USER_SERVICE.users[0].id {
                    self.addMember(id: uid )
                }
            }
        }
        
        userNotification =  NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.USERS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let user : User = obj.object as? User {
                self.addMember(id: user.id)
            }
        }
        
    }
    
    func willAppear() {
        for family in Constants.Services.FAMILY_SERVICE.families {
            for uid in family.members {
                addMember(id: uid)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(userNotification)
    }
    func addMember(id: String) -> Void {
        if Constants.Services.USER_SERVICE.users.index(where: {$0.id == id}) != nil{
            self.collectionView.reloadData()
        }else{
            Constants.Services.REF_SERVICE.valueSingleton(ref: "users/\(id)")
        }
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
            let user = Constants.Services.USER_SERVICE.users[indexPath.row+1]
            if shareEventDelegate.event.members.contains( where: {$0 == user.id}) {
                cell.bind(userModel: user)
            }else{
                cell.bind(userModel: user , filter: "blackwhite")
            }
        }
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
            if !shareEventDelegate.event.members.contains(where: {$0 == cell.userModel?.id}){
                shareEventDelegate.event.members.append((cell.userModel?.id)!)
            }
        }else{
            cell.profileImage.blackwhite(urlString: (cell.userModel?.photoURL)!)
            if let index = shareEventDelegate.event.members.index(where: {$0 == cell.userModel?.id }){
                shareEventDelegate.event.members.remove(at: index)
            }
        }
        print(shareEventDelegate.event)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
 
   
}
