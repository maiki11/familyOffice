//
// Created by Enrique Moya on 27/06/17.
// Copyright (c) 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

public class GalleryService {


    var albums = [Album]




    func getImages(album: Album) {
        if album.images.count > 0 {
            self.images.forEach({ imageId in
                Constants.FirDatabase.REF.child("images/\(imageId)").observeSingleEvent(of: .value, with: {snapshot in
                    album.ObjImages.append(ImageAlbum(snap: snapshot))
                })
            })
        }
    }
}