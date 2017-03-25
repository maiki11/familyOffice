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

class FamilyCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate  {
    //Internal var
    var indexP : IndexPath? = nil
    var family : Family?
    var longPressTarget: (cell: UICollectionViewCell, indexPath: NSIndexPath)?
    //UI
    @IBOutlet var familyCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.familyCollection.addGestureRecognizer(lpgr)
        self.clearsSelectionOnViewWillAppear = true
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)]
        
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == FAMILY_SERVICE.families.count){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }else{
            self.family = FAMILY_SERVICE.families[indexPath.row]
            self.performSegue(withIdentifier: "changeScreen", sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeScreen" {
            let viewController = segue.destination as! FamilyViewController
            viewController.family = family!
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        for item in FAMILY_SERVICE.families {
            if item.members?[(FIRAuth.auth()?.currentUser?.uid)!] == nil {
                FAMILY_SERVICE.families.remove(at:  FAMILY_SERVICE.families.index(where: {$0.id == item.id})!)
            }
        }
        
        return FAMILY_SERVICE.families.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Family Cell
        if ( indexPath.row < FAMILY_SERVICE.families.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FamilyCollectionViewCell
            let family = FAMILY_SERVICE.families[indexPath.row]
            cell.name.text = family.name
            // Bounce back to the main thread to update the UI
            if !(family.photoURL?.isEmpty)! {
                cell.imageFamily.loadImage(urlString: (family.photoURL)!)
            }
            return cell
        }
        //Add Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.size.width/16
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        longPressTarget = ((cell: collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FamilyCollectionViewCell), indexPath: indexPath)
    }
    //Long press
       
}
