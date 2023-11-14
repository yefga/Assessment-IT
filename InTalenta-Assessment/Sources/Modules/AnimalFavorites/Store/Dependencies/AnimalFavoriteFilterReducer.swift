//
//  AnimalFavoriteFilterReducer.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 14/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalFavoriteFilterReducer: Reducer {
    
    @Dependency(\.getPhotos) var getPhotos
    
    enum Action: Equatable {
        case viewDidLoad
        case fetchAnimal
        case filter(Int, Bool)
        case getAnimal(TaskResult<[String]>)
    }
    
    struct State: Equatable {
        var animals: [AnimalFavoriteFilterModel] = []
        var filter: [String] = []
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewDidLoad:
            break
        case .filter(let index, let isEnabled):
            state.animals[index].isSelected = isEnabled
//            print(state.animals[index])
//            let animal = state.animals[index].name
//            if isEnabled {
//                state.filter.append(animal)
//            } else {
//                state.filter.remove(at: index)
//            }
                        
        case .fetchAnimal:
           break
            
        case .getAnimal(.success(let animals)):
            break
            
        default: break
        }
        return .none
    }
}
