//
// Created by Enrique Moya on 27/06/17.
// Copyright (c) 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

public class GalleryService {


    var albums: [Album] = []




    func getImages(album: Album) -> [ImageAlbum] {
        var returnImages: [ImageAlbum] = []
        if album.images.count > 0 {
            album.images.forEach({ imageId in
                Constants.FirDatabase.REF.child("images/\(imageId)").observeSingleEvent(of: .value, with: {snapshot in
                     returnImages.append(ImageAlbum(snap: snapshot))
                })
            })
        }
        return returnImages
    }
}
