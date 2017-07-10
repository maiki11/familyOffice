//
//  AlbumViewController.swift
//  familyOffice
//
//  Created by Enrique Moya on 05/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import ReSwift
import Firebase

class AlbumViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = GalleryState

    var currentAlbum: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addImage))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "Albums"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func addImage() {
        self.performSegue(withIdentifier: "AddImageSegue", sender: nil)
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
extension AlbumViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        service.GALLERY_SERVICE.initObserves(ref: service.GALLERY_SERVICE.activeAlbum!, actions: [.childAdded])
        store.subscribe(self){
            state in
            state.GalleryState
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        store.unsubscribe(self)
        service.GALLERY_SERVICE.removeHandles()
    }
    func newState(state: GalleryState) {
        if service.GALLERY_SERVICE.albums.contains(where: {$0.id == service.GALLERY_SERVICE.activeAlbum}){
            currentAlbum = service.GALLERY_SERVICE.albums.first(where: {$0.id == service.GALLERY_SERVICE.activeAlbum})!
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

