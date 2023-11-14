//
//  AnimalReducer.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 05/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalReducer: Reducer {
    
    @Dependency(\.searchAnimal) var searchAnimal
    @Dependency(\.continuousClock) var clock
    
    enum Cancel: Equatable {
        case debounce
    }
    
    enum Action: Equatable {
        case viewDidLoad
        case getDefaultAnimals
        case getAnimalResponse(TaskResult<[AnimalDataModel?]>)
        case searchAnimal(String)
        case refresh
    }
    
    struct State: Equatable {
        var animals: [String] = []
        var loading: Bool = false
        var errorMessage: String = ""
        var viewState: ViewState = .none
        var totalResults: Int = 0
        var keyword: String = ""
    }
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .refresh:
            state.viewState = .refresh
            return .send(.searchAnimal(state.keyword))
            
        case .viewDidLoad:
            state.viewState = .loading
            return .send(.getDefaultAnimals)
            
        case .getDefaultAnimals:
            state.keyword = ""
            state.viewState = .success(empty: false)
            state.animals = [
                "Elephant",
                "Lion",
                "Fox",
                "Dog",
                "Shark",
                "Turtle",
                "Whale",
                "Penguin"
            ]
            
        case .searchAnimal(let keyword):
            if keyword.count > 1 {
                state.keyword = keyword
                return .run(priority: .userInitiated) { [name = keyword] send in
                    try await self.clock.sleep(for: .seconds(0.3))
                    await send(.getAnimalResponse(
                        TaskResult {
                            try await self.searchAnimal.search(name) ?? []
                        })
                    )
                }
            } else {
                return .send(.getDefaultAnimals)
            }
            
        case .getAnimalResponse(.failure(let error)):
            state.errorMessage = error.localizedDescription
            
        case .getAnimalResponse(.success(let data)):
            state.animals.removeAll()
            
            let animals = data.compactMap {
                $0?.name
            }
            state.viewState = .success(empty: data.isEmpty)
            state.animals = animals
        }
        
        return .none

    }
}

