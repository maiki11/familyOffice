//
//  HomeGalleryViewController.swift
//  familyOffice
//
//  Created by mac on 23/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import ReSwift
import Firebase
class HomeGalleryViewController: UIViewController {
    var personal:[Album] = []

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionSegmentcontrol: UISegmentedControl!
    var familiar:[Family] = []
    
    let key: String = service.USER_SERVICE.users[0].id
    
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
        self.performSegue(withIdentifier: "AddAlbumSegue", sender: nil)
    }

}
extension HomeGalleryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectionSegmentcontrol.selectedSegmentIndex == 0 {
            return self.personal.count
        }else{
            return self.familiar.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch selectionSegmentcontrol.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
            let album = personal[indexPath.item]
            cell.bind(album: album)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! FamilyGalleryCollectionViewCell
            let family = service.FAMILY_SERVICE.families[indexPath.item]
            cell.bind(fam: family)
            return cell
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(selectionSegmentcontrol.selectedSegmentIndex == 0){
            return CGSize(width: 150, height: 130)
        }else{
            return CGSize(width: 310, height: 130)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectionSegmentcontrol.selectedSegmentIndex{
        case 0: break
        default: break
        }
        
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        collectionView.reloadItems(at: [indexPath])
    }


}

extension HomeGalleryViewController: StoreSubscriber{
    typealias StoreSubscriberStateType = GalleryState

    override func viewWillAppear(_ animated: Bool) {
        
        service.GALLERY_SERVICE.initObserves(ref: "album/\(key)", actions: [.childAdded])
        
        store.subscribe(self){
            state in
            state.GalleryState
        }
        
        
        // self.familiar = service.FAMILY_SERVICE.families
        //        service.GALLERY_SERVICE.fillAlbums(reference: key, callback: { bool in
        //            if bool{
        //                self.personal = service.GALLERY_SERVICE.albums
        //                self.collectionView.reloadData()
        //            }
        //        })
    }
    func newState(state: GalleryState) {
        personal = state.Gallery[key] ?? []
        self.collectionView?.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        store.unsubscribe(self)
        service.GALLERY_SERVICE.removeHandles()
    }
}
