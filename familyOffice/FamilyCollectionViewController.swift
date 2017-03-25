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
<<<<<<< Updated upstream
    var indexP : IndexPath? = nil
=======
    var families : [Family] = []
>>>>>>> Stashed changes
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
        
<<<<<<< Updated upstream
        
    }
        
=======
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                REF_FAMILIES.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let family = Family(snapshot: snapshot)
                    if (FAMILY_SERVICE.duplicate(id: family.id)){
                        FAMILY_SERVICE.families.append(family)
                        self.families.append(family)
                        self.collectionView?.reloadData()
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        })
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.families = FAMILY_SERVICE.families
        self.collectionView?.reloadData()
        Utility.Instance().clearObservers()
    }
>>>>>>> Stashed changes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
<<<<<<< Updated upstream
        if(indexPath.row == FAMILY_SERVICE.families.count){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }else{
            self.family = FAMILY_SERVICE.families[indexPath.row]
            self.performSegue(withIdentifier: "changeScreen", sender: nil)
        }
=======
        if(indexPath.row == families.count){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }else{
            self.family = families[indexPath.row]
            self.performSegue(withIdentifier: "changeScreen", sender: nil)
        }
        
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
        return families.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Family Cell
        if ( indexPath.row < families.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FamilyCollectionViewCell
            let family = families[indexPath.row]
            
            cell.name.text = family.name
            if let data = STORAGE_SERVICE.search(url: (family.photoURL?.absoluteString)!) {
                cell.imageFamily.image = UIImage(data: data)
            }
            // Configure the cell
            
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
       
=======
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < families.count) {
            switch gestureReconizer.state {
            case .began:
                let family = families[(indexPath?.row)!]
    
                // create the alert
                let alert = UIAlertController(title: family.name, message: "¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Seleccionar", style: UIAlertActionStyle.default, handler: {action in
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        self.toggleSelect(family: family)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                if(family.admin == FIRAuth.auth()?.currentUser?.uid){
                    alert.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.destructive, handler:  { action in
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                            self.togglePendingDelete(family: family)
                            self.families.remove(at: (indexPath?.row)!)
                            self.collectionView?.deleteItems(at: [indexPath!])
                        }
                        
                    }))
                }
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                break
            case .ended:
                print("termine")
                break
            default:
                break
            }
        }
    }
    
    func toggleSelect(family: Family){
        FAMILY_SERVICE.selectFamily(family: family)
    }
    
    func togglePendingDelete(family: Family) -> Void
    {
        FAMILY_SERVICE.delete(family: family)
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
>>>>>>> Stashed changes
}
