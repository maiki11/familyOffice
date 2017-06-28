//
//  AlbumModel.swift
//  familyOffice
//
//  Created by mac on 26/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabase.FIRDatabaseReference

struct Album {
    static let kId = "Id"
    static let kCover = "cover"
    static let kTitle = "title"
    static let kImage = "images"

    var id: String!
    var cover: String!
    var title: String!
    var images: [String] = []
    var ObjImages: [ImageAlbum] = []

    init(){
        self.id = ""
        self.cover = ""
        self.title = ""
        self.images = []
    }
    init(id: String,cover: String = "",title: String,images: [String]){
        self.id = id
        self.cover = cover
        self.title = title
        self.images = images
    }
    init(snapshot: FirebaseDatabase.FIRDataSnapshot){
        self.id = snapshot.key
        let snapValue = snapshot.value as! NSDictionary
        self.cover = service.UTILITY_SERVICE.exist(field: Album.kCover, dictionary: snapValue)
        self.title = service.UTILITY_SERVICE.exist(field: Album.kTitle, dictionary: snapValue)
        self.images = service.UTILITY_SERVICE.exist(field: Album.kImage, dictionary: snapValue)
        
    }
    mutating
    func toDictionary() -> NSDictionary {
        return [
                Album.kTitle: self.title,
                Album.kImage: self.images,
                Album.kCover: self.cover
        ]
    }
}
protocol AlbumBindable: AnyObject {
    var album: Album? {get set}
    var titleLabel: UIKit.UILabel! {get}
    var imageBackground: UIKit.UIImageView! {get}
}
extension AlbumBindable{
    var titleLabel: UIKit.UILabel!{
        return nil
    }
    var imageBackground: UIKit.UIImageView!{
        return nil
    }
    //Bind Ninja
    func bind(album: Album){
        self.album = album
        bind()
    }
    func bind() {
        guard let album = self.album else{
            return
        }
        if let titleLabel = self.titleLabel{
            if album.title != nil{
                titleLabel.text = (album.title?.isEmpty)! ? "Sin título" : album.title
            }else{
                titleLabel.text = "Sin título"
            }
        }
        if let imageBackground = self.imageBackground{
            if album.cover != nil{
                if(album.cover?.isEmpty)!{
                    imageBackground.loadImage(urlString: album.cover)
                }
            }
        }
    }
}

