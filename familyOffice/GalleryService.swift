//
// Created by Enrique Moya on 27/06/17.
// Copyright (c) 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDatabaseReference
import FirebaseDatabase.FIRDatabaseQuery
import FirebaseStorage.FIRStorage
import FirebaseStorage.FIRStorageMetadata

public class GalleryService : RequestService {


    var handles: [(String, UInt)] = []

    var albums: [Album] = []
    var saveAlbums: [String:[Album]] = [:]
    var activeAlbum: String!

    private init() {}

    static private let instance = GalleryService()

    public static func Instance() -> GalleryService {
        return instance
    }

    func initObserves(ref: String, actions: [FIRDataEventType]) -> Void {
        for action in actions {
            self.child_action(ref: ref, action: action)
        }
    }
    func routing(snapshot: FIRDataSnapshot, action: FIRDataEventType, ref: String) {
        switch action {
        case .childAdded:
            self.added(snapshot: snapshot)
            break
        case .childRemoved:
            self.removed(snapshot: snapshot)
            break
        case .childChanged:
            self.updated(snapshot: snapshot, id: snapshot.key)
            break
        case .value:
            self.add(value: snapshot)
            break
        default:
            break
        }
    }

    func addHandle(_ handle: UInt, ref: String) {
    }

    func removeHandles() {
    }

    func inserted(ref: FIRDatabaseReference) {
    }

    
    func update(_ ref: String, value: [AnyHashable : Any], callback: @escaping ((Any) -> Void)) {
    }
    func delete(_ ref: String, callback: @escaping ((Any) -> Void)) {
    }

}
extension GalleryService: repository {

    func fillAlbums(reference: String,callback: @escaping((Bool) -> Void)){
        Constants.FirDatabase.REF.child("album/\(reference)").observe(.value, with: {snapshot in
            if let snap = snapshot as? FIRDataSnapshot, snap != nil{
                for item in snap.children{
                    let albumAux: Album = Album(snapshot: item as! FIRDataSnapshot)
                    if !self.albums.contains(where: {$0.id == albumAux.id}){
                        self.albums.append(albumAux)
                    }
                }
                callback(true)
            }else{
                callback(false)
            }
        })
    }

    func added(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        if !self.albums.contains(where: {$0.id == snapshot.key}){
            var album = Album(snapshot: snapshot)
            self.getImages(album: album, callback: {images in
                if images is [ImageAlbum]{
                    album.ObjImages = images as! [ImageAlbum]
                    if self.albums.filter({ (Album) -> Bool in
                        Album.id == album.id
                    }).count == 0{
                        self.albums.append(album)
                    }
                }
            })
        }
    }

    func add(value: FIRDataSnapshot) -> Void {
    }

    func updated(snapshot: FirebaseDatabase.FIRDataSnapshot, id: Any) {
    }

    func removed(snapshot: FirebaseDatabase.FIRDataSnapshot) {
        if let index = albums.index(where: {$0.id == snapshot.key}){
            self.albums.remove(at: index)
            NotificationCenter.default.post(name: notCenter.SUCCESS_NOTIFICATION, object: nil)
        }
    }
    func createAlbum(data: NSDictionary,callback: @escaping (Any)-> Void){
        var album = data.value(forKey: "album") as! Album
        if data.value(forKey: "file") != nil {
            service.STORAGE_SERVICE.insert(data.value(forKey: "reference-img") as! String, value: data.value(forKey: "file") as Any, callback: { metadata in
                if let meta = metadata as? FIRStorageMetadata{
                    album.cover = (meta.downloadURL()?.absoluteString)!
                    service.GALLERY_SERVICE.insert(data.value(forKey: "reference") as! String, value: album.toDictionary(), callback: {reference in
                        if let ref = reference as? FIRDatabaseReference{
                            ref.observeSingleEvent(of: .value, with: {snapshot in
                                callback("Guardado correctamente")
                            })
                        }else{
                            callback("Error")
                        }
                    })
                }else{
                    callback("Error")
                }
            })
        }else{
            service.GALLERY_SERVICE.insert(data.value(forKey: "reference") as! String, value: album.toDictionary(), callback: {reference in
                if let ref = reference as? FIRDatabaseReference{
                    ref.observeSingleEvent(of: .value, with: {snapshot in
                        let aux = Album(snapshot: snapshot)
                        callback("Guardado sin portada")
                    })
                }else{
                    callback("Error")
                }
            })
        }
    }
    func getImages(album: Album, callback: @escaping ((Any) -> Void)) {
        var returnImages: [ImageAlbum] = []
        if album.images.count > 0 {
            album.images.forEach({ imageId in
                Constants.FirDatabase.REF.child("images/").queryEqual(toValue: album.id, childKey: imageId as String).observeSingleEvent(of: .value, with: {snapshot in
                    for item in snapshot.children{
                        returnImages.append(ImageAlbum(snap: item as! FIRDataSnapshot))
                    }
                    print(returnImages)
                    callback(returnImages as [ImageAlbum])
                })
            })
        }
    }
}
