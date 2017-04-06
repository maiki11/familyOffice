//
//  FamilyCollectionViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 19/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
private let reuseIdentifier = "cell"

class FamilyCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate  {
    @IBOutlet weak var mainView: UIView!
    //Internal var
    var indexP : IndexPath? = nil
    var family : Family?
    var longPressTarget: (cell: UICollectionViewCell, indexPath: IndexPath)?
    //UI
    @IBOutlet var familyCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.familyCollection.addGestureRecognizer(lpgr)
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]

        self.familyCollection.layer.cornerRadius = 8
        self.familyCollection.clipsToBounds = true
        self.mainView.layer.cornerRadius = 5
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeScreen" {
            let viewController = segue.destination as! FamilyViewController
            viewController.family = family!
        }
    }
       
}


extension FamilyCollectionViewController {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == FAMILY_SERVICE.families.count){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }else{
            self.family = FAMILY_SERVICE.families[indexPath.row]
            self.performSegue(withIdentifier: "changeScreen", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        for item in FAMILY_SERVICE.families {
            if item.members?[(FIRAuth.auth()?.currentUser?.uid)!] == nil {
                FAMILY_SERVICE.families.remove(at:  FAMILY_SERVICE.families.index(where: {$0.id == item.id})!)
            }
        }
        
        return FAMILY_SERVICE.families.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Family Cell
        if ( indexPath.row < FAMILY_SERVICE.families.count){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FamiliesPreCollectionViewCell
            
            let family = FAMILY_SERVICE.families[indexPath.row]
            cell.check.layer.cornerRadius = 15
            cell.check.layer.borderWidth = 2
            cell.check.layer.borderColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1).cgColor
            // Bounce back to the main thread to update the UI
            if !(family.photoURL?.isEmpty)! {
                cell.image.loadImage(urlString: (family.photoURL)!)
                cell.image.layer.borderWidth = 1.0
                cell.image.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
                
            }
            cell.name.text = family.name
            cell.check.isHidden = true
            cell.name.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
            if family.id == USER_SERVICE.users[0].familyActive {
                cell.check.isHidden = false
                cell.name.textColor = #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)
            }
            return cell
        }
        //Add Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! addCell

        return cell
    }
    
   
}
