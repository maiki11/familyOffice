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
    //Internal var
    var indexP : IndexPath? = nil
    var family : Family?
    var longPressTarget: (cell: UICollectionViewCell, indexPath: NSIndexPath)?
    //UI
    @IBOutlet var familyCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(FamilyCollectionViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.familyCollection.addGestureRecognizer(lpgr)
        self.clearsSelectionOnViewWillAppear = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
        if (FAMILY_SERVICE.families.count == 0){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
        NotificationCenter.default.addObserver(forName: FAMILYADDED_NOTIFICATION, object: nil, queue: nil){ notification in
            self.collectionView?.insertItems(at: [IndexPath(item: FAMILY_SERVICE.families.count-1, section: 0)])
        }
        NotificationCenter.default.addObserver(forName: FAMILYREMOVED_NOTIFICATION, object: nil, queue: nil){index in
            self.collectionView?.deleteItems(at: [IndexPath(item: index.object as! Int, section: 0)])
            if (FAMILY_SERVICE.families.count == 0){
                UTILITY_SERVICE.gotoView(view: "RegisterFamilyView", context: self)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(FAMILYREMOVED_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYADDED_NOTIFICATION)
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
        return FAMILY_SERVICE.families.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Family Cell
        if ( indexPath.row < FAMILY_SERVICE.families.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FamilyCollectionViewCell
            let family = FAMILY_SERVICE.families[indexPath.row]
            
            cell.name.text = family.name
            // Bounce back to the main thread to update the UI
            
            if let data = STORAGE_SERVICE.search(url: (family.photoURL?.absoluteString)!) {
                cell.activityindicator.stopAnimating()
                cell.imageFamily.image = UIImage(data: data)
                
            }
            
            
            // Configure the cell
            
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
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < FAMILY_SERVICE.families.count) {
            switch gestureReconizer.state {
            case .began:
                let family = FAMILY_SERVICE.families[(indexPath?.row)!]
                
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
                            //self.collectionView?.deleteItems(at: [indexPath!])
                            
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
    
    
}
