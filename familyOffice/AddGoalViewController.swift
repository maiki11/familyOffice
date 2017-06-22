//
//  AddGoalViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController{
    var types = [("Deportivo","sport"),("Escolar","school"),("Alimentación","eat"),("Salud","health-1"),("Negocios","business-1"),("Religión","religion")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddGoalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! typeiconCollectionViewCell
        let obj = types[indexPath.row]
        cell.titleLbl.text = obj.0
        cell.photo.image = UIImage(named: obj.1)
        return cell
    }
}


