//
//  HomeGalleryViewController.swift
//  familyOffice
//
//  Created by mac on 23/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class HomeGalleryViewController: UIViewController {
    let personal = [2,3,4,5,6]

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionSegmentcontrol: UISegmentedControl!
    let familiar = [9,9,9,7,6,5,4,3,2,1]
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.AddAlbum))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "Albums"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func changeSelection(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        if(selectionSegmentcontrol.selectedSegmentIndex == 0){
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.AddAlbum))
            self.navigationItem.rightBarButtonItem = addButton
            self.navigationItem.title = "Albums"
        }else{
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Familias"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func AddAlbum() {

    }

}
extension HomeGalleryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
        
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(selectionSegmentcontrol.selectedSegmentIndex == 0){
            return CGSize(width: 150, height: 130)
        }else{
            return CGSize(width: 310, height: 130)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        collectionView.reloadItems(at: [indexPath])
    }
    


}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:  .random(),
                green: .random(),
                blue:  .random(),
                alpha: 1.0)
    }
}
