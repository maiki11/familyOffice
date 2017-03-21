//
//  FamilyCollectionExtension.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Toast_Swift
import FirebaseAuth

extension FamilyCollectionViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        createListeners()
        
        if (FAMILY_SERVICE.families.count == 0){
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
        NotificationCenter.default.addObserver(forName: FAMILYADDED_NOTIFICATION, object: nil, queue: nil){ notification in
            if modelName == "iPhone 5s" {
                self.collectionView?.reloadData()
            }else{
                if (self.collectionView?.numberOfItems(inSection: 0))! <= FAMILY_SERVICE.families.count {
                    self.collectionView?.insertItems(at: [IndexPath(item: FAMILY_SERVICE.families.count-1, section: 0)])
                    
                }
            }
        }
        NotificationCenter.default.addObserver(forName: FAMILYREMOVED_NOTIFICATION, object: nil, queue: nil){index in
            if modelName == "iPhone 5s" {
                self.collectionView?.reloadData()
            }else{
                
                if (self.collectionView?.numberOfItems(inSection: 0))! - 1 > FAMILY_SERVICE.families.count {
                    self.collectionView?.deleteItems(at: [IndexPath(item: index.object as! Int, section: 0)])
                    self.collectionView?.reloadData()
                }
            }
            if (FAMILY_SERVICE.families.count == 0){
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: FAMILYUPDATED_NOTIFICATION, object: nil, queue: nil){index in
            if (self.collectionView?.numberOfItems(inSection: 0))! > 0, let index = index.object as? Int {
                self.collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deleteListeners()
        NotificationCenter.default.removeObserver(FAMILYUPDATED_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYREMOVED_NOTIFICATION)
        NotificationCenter.default.removeObserver(FAMILYADDED_NOTIFICATION)
    }
    
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
    func createListeners() -> Void {
        for item in FAMILY_SERVICE.families {
            REF_SERVICE.childChanged(ref: "families/\((item.id)!)")
        }
    }
    func deleteListeners() -> Void {
        for item in FAMILY_SERVICE.families {
            REF_SERVICE.remove(ref: "families/\((item.id)!)")
        }
    }
    


}
