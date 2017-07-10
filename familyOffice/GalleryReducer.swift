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
        var stateAux = state ?? GalleryState(Gallery: [:], status: .none)
        switch action {
        case let action as InsertGalleryAction:
            insert(album: action.album)
            stateAux.status = .loading
            return stateAux
        default:
            break
        }
        return stateAux
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
