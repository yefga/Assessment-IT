//
//  AnimalFavoriteReducer.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalFavoriteReducer: Reducer {
    
    @Dependency(\.getPhotos) var getPhotos
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .viewWillAppear:
            return .send(.fetchPhotos)
            
        case .fetchPhotos:
            state.viewState = .loading
            return .run(priority: .background) { send in
                await send(
                    .getPhotos(
                        TaskResult { try await self.getPhotos.fetchAll() }
                    )
                )
            }
            
        case .getPhotos(.success(let model)):
            state.photos = model
            state.storedPhotos = model
            let setAnimal = Set(model.map({ $0.category ?? "" }))
            let arrayAnimal = Array(setAnimal)
            arrayAnimal.forEach { animal in
                if !state.setAnimal.contains(.init(name: animal)) {
                    state.setAnimal.append(.init(name: animal))
                }
            }
            
            state.viewState = .success(empty: model.isEmpty)
            if state.storedPhotos.count == 1 {
                state.titleLabel = "There is \(state.storedPhotos.count) photo in your favorite."
            } else {
                state.titleLabel = "There are \(state.storedPhotos.count) photos in your favorite."
            }
            
            
        case .refresh:
            return .send(.fetchPhotos)
            
        case .filter(let animals):
            let filtered = animals.filter { $0.isSelected }.map { $0.name }
            state.photos = state.storedPhotos.filter({
                filtered.contains($0.category ?? "")
            })
            for (index, item) in state.setAnimal.enumerated() {
                state.setAnimal[index].isSelected = filtered.contains(item.name)
            }
            state.titleLabel = "\(state.photos.count) Photos, filtered by \(filtered.joined(separator: ", "))"
            
        default:
            break
        }
        
        return .none
    }
    
    struct State: Equatable {
        var photos: [AnimalDBModel] = []
        var setAnimal: [AnimalFavoriteFilterModel] = []
        var viewState: ViewState = .none
        var storedPhotos: [AnimalDBModel] = []
        var titleLabel: String = ""
    }
    
    enum Action: Equatable, Sendable {
        case viewWillAppear
        case fetchPhotos
        case getPhotos(TaskResult<[AnimalDBModel]>)
        case filter([AnimalFavoriteFilterModel])
        case refresh
    }
    
}
