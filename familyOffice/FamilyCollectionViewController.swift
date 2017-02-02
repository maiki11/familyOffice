//
//  FamilyCollectionViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 19/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "cell"

class FamilyCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate  {
    var families : [Family] = []
    var ref: FIRDatabaseReference!
    var family : Family?
    let familyService = FamilyService.instance
    var longPressTarget: (cell: UICollectionViewCell, indexPath: NSIndexPath)?
    
    @IBOutlet var familyCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(FamilyCollectionViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.familyCollection.addGestureRecognizer(lpgr)
        self.clearsSelectionOnViewWillAppear = true
        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                REF_FAMILIES.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let family = Family(snapshot: snapshot)
                    if (self.familyService.duplicate(id: family.id)){
                        self.familyService.families.append(family)
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
        self.families = familyService.families
        self.collectionView?.reloadData()
        Utility.Instance().clearObservers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.family = families[indexPath.row]
        self.performSegue(withIdentifier: "changeScreen", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeScreen" {
            let viewController  = segue.destination as! FamilyViewController
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
        return families.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FamilyCollectionViewCell
        let family = families[indexPath.row]
        
        cell.name.text = family.name
        cell.imageFamily.image = UIImage(data: family.photoData!)
        
        // Configure the cell
    
        return cell
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        longPressTarget = ((cell: collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FamilyCollectionViewCell), indexPath: indexPath)
    }
    //Long press
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if indexPath != nil {
            switch gestureReconizer.state {
            case .began:
                let family = families[(indexPath?.row)!]
                if family != nil{
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
                }
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
        FamilyService.instance.selectFamily(family: family)
    }
    
    func togglePendingDelete(family: Family) -> Void
    {
        FamilyService.instance.delete(family: family)
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

}
