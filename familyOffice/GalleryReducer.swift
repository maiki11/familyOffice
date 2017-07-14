//
//  GalleryReducer.swift
//  familyOffice
//
//  Created by Enrique Moya on 06/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
struct GalleryReducer: Reducer {
    func handleAction(action: Action, state: GalleryState?) -> GalleryState {
        var stateAux = state ?? GalleryState(Gallery: [:], Album: Album(), status: .none)
        switch action {
        case let action as InsertGalleryAction:
            insert(album: action.album)
            stateAux.status = .loading
            return stateAux
        case let action as InsertImagesAlbumAction:
            addImage(image: action.image)
            stateAux.status = .none
            return stateAux
        default:
            break
        }
        return stateAux
    }
    func addImage(image: ImageAlbum) {
        service.IMAGEALBUM_SERVICE.InsertImage(image: image)
        return
    }
    func insert(album: NSDictionary){
        service.GALLERY_SERVICE.createAlbum(data: album, callback: {errors in
            if errors == "Guardado sin portada" || errors == "Guardado correctamente"{
                let data = album["album"] as! Album
                let id = (album["reference"] as! String).components(separatedBy: "/")[1]
                store.state.GalleryState.Gallery[id]?.append(data)
                store.state.GalleryState.status = .Finished(errors)
            }else{
                store.state.GalleryState.status = .failed
            }
        })
    }
}
