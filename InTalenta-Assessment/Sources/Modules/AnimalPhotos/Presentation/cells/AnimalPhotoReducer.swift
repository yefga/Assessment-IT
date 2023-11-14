//
//  AnimalPhotoReducer.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalPhotoReducer: Reducer {
    
    enum Action: Equatable {
        case load(PhotoModel)
        case checkFavorite(Int)
        case favorite(Bool)
    }
    
    struct State: Equatable {
        var isFavorite: Bool = false
        var photo: PhotoModel?
        var photoThumbnail: String?
    }
    
    func reduce(into state: inout State,
                action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .load(let photoModel):
            state.photoThumbnail = photoModel.src?.tiny
        case .favorite(let isFavorite):
            state.isFavorite = isFavorite
        default: break
        }
        return .none
    }
    
}
