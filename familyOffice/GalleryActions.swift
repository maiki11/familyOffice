//
//  GalleryActions.swift
//  familyOffice
//
//  Created by Enrique Moya on 06/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import Foundation
import ReSwift

struct InsertGalleryAction: Action {
    let album: NSDictionary
}
struct DeleteGalleryAction: Action {
    let album: Album
}

struct GetGalleyAction: Action {
}
struct InsertImagesAlbumAction: Action {
    let image: ImageAlbum
    init(image: ImageAlbum){
        self.image = image
    }
}
