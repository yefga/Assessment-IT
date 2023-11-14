//
//  AnimalDetailReducer.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalDetailReducer: Reducer {
    
    @Dependency(\.getPhotos) var getPhotos
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .favorite:
            guard let data = state.data else {
                return .none
            }
            
            if state.isFavorite {
                return .send(.removeFavorite(state.animal, data))
            } else {
                return .send(.addFavorite(state.animal, data))
            }
            
        case .addFavorite(let animal, let photo):
            return .run(priority: .userInitiated) { send in
                await send(
                    .localResponse(
                        TaskResult { try await self.getPhotos.addFavorite(animal, photo) }
                    )
                )
            }
            
        case .localResponse(.success(.addSuccess)):
            state.isFavorite = true
        
        case .localResponse(.success(.deleteSuccess)):
            state.isFavorite = false
            
            
        case .removeFavorite(let animal, let photo):
            return .run(priority: .userInitiated) { [photoID = photo.id ?? 0] send in
                await send(
                    .localResponse(
                        TaskResult { try await self.getPhotos.removeFavorite(animal, photoID) }
                    )
                )
            }
            
        case .viewDidLoad:
            return .send(.fetchPhoto(state.id))
        case .fetchPhoto(let photoID):
            return .run { [id = photoID] send in
                await send(.fetchResponse(
                    TaskResult {
                        try await self.getPhotos.fetchDetail(id)
                    }
                ))
            }
        case .fetchResponse(.success(let model)):
            state.data = model
        default:
            break
        }
        return .none
    }
    
    struct State: Equatable {
        let id: String
        let animal: String
        var isFavorite: Bool = false
        var data: PhotoModel?
    }
    
    enum Action: Equatable {
        case viewDidLoad
        case fetchPhoto(String)
        case fetchResponse(TaskResult<PhotoModel?>)
        case favorite
        case addFavorite(String, PhotoModel)
        case localResponse(TaskResult<CoreDataResult>)
        case removeFavorite(String, PhotoModel)
    }
    
    
}
