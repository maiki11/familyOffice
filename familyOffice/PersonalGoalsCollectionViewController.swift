//
//  PersonalGoalsCollectionViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 20/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

private let reuseIdentifierT1 = "type1-goalCell"

class PersonalGoalsCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleNew))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        self.navigationItem.rightBarButtonItem = addButton
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let nib_type1 = UINib(nibName: "Type1_GoalCollectionViewCell", bundle: nil)
        collectionView?.register(nib_type1, forCellWithReuseIdentifier: reuseIdentifierT1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        service.GOAL_SERVICE.initObserves(ref: "users/\(service.USER_SERVICE.users[0].id!)/goals", actions: [.childAdded,.childChanged,.childRemoved])
        NotificationCenter.default.addObserver(forName: notCenter.SUCCESS_NOTIFICATION, object: nil, queue: nil, using: {obj in
                self.collectionView?.reloadData()
            
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        service.GOAL_SERVICE.removeHandles()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleNew() -> Void {
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let vc = segue.destination as! AddGoalViewController
            vc.bind(goal: Goal())
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.GOAL_SERVICE.goals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierT1, for: indexPath) as! Type1_GoalCollectionViewCell
        cell.bind(goal: service.GOAL_SERVICE.goals[indexPath.item])
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
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
