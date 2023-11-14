//
//  AnimalPhotosReducer.swift
//  InTalenta-Assessment
//
//  Created by pro on 10/11/23.
//

import Foundation
import ComposableArchitecture

struct AnimalPhotosReducer: Reducer {
        
    @Dependency(\.getPhotos) var getPhotos
    
    enum Action: Equatable {
        case viewWillAppear
        case viewDidLoad
        case getPhotos(String)
        case loadMore
        case favorite(index: Int)
        case refresh
        case addFavorite(String, PhotoModel)
        case localResponse(TaskResult<CoreDataResult>)
        case removeFavorite(String, PhotoModel)
        case getFavorites
        case getFavoritesResponse(TaskResult<[String]>)
        case getPhotosResponse(TaskResult<PexelsModel?>)
    }
    
    struct State: Equatable {
        var animal: String
        var photos: [PhotoModel] = []
        var viewState: ViewState = .none
        var errorMessage: String?
        var requestParameter: RequestPhoto?
        var totalPhotos: Int = 0
        var nextPage: String?
        var title = ""
    }
    
    func reduce(
        into state: inout State,
        action: Action
    ) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .viewWillAppear:
            if !state.photos.isEmpty {
                return.send(.getFavorites)
            }
            
        case .refresh:
            state.viewState = .refresh
            return .send(.viewDidLoad)
            
        case .addFavorite(let animal, let photo):
            return .run(priority: .userInitiated) { send in
                await send(
                    .localResponse(
                        TaskResult { try await self.getPhotos.addFavorite(animal, photo) }
                    )
                )
            }
            
        case .localResponse(.success(.addSuccess)):
            print("success add")
        
        case .localResponse(.success(.deleteSuccess)):
            print("success delete")
            
        case .localResponse(.success(.error(let message))):
            state.errorMessage = message
            
        case .removeFavorite(let animal, let photo):
            return .run(priority: .userInitiated) { [photoID = photo.id ?? 0] send in
                await send(
                    .localResponse(
                        TaskResult { try await self.getPhotos.removeFavorite(animal, photoID) }
                    )
                )
            }

            
        case .getFavorites:
            return .run(priority: .background) { [animalName = state.requestParameter?.query] send in
                await send(
                    .getFavoritesResponse(
                        TaskResult { try await self.getPhotos.fetchFavorite(animalName ?? "") }
                    )
                )
            }
            
        case .getFavoritesResponse(.success(let photoID)):
            let id = photoID.map { Int($0) }
            for (index, photo) in state.photos.enumerated() {
                if id.contains(photo.id) {
                    state.photos[index].isFavorite = true
                } else {
                    state.photos[index].isFavorite = false
                }
            }
            
        case .getFavoritesResponse(.failure):
            return .none
            
        case .viewDidLoad:
            return .send(.getPhotos(state.animal))
            
        case .getPhotos(let animal):
            if state.requestParameter == nil {
                state.viewState = .loading
                state.requestParameter = .init(query: animal)
            }
            
            return .run(priority: .background) { [param = state.requestParameter] send in
                await send(
                    .getPhotosResponse(
                        TaskResult { try await self.getPhotos.fetch(param) ?? nil }
                    )
                )
            }
            
        case .loadMore:
            if let _ = state.nextPage {
                state.viewState = .more
                return .send(.getPhotos(state.animal))
            }
            
        case .favorite(let index):
            state.photos[index].isFavorite.toggle()
            if state.photos[index].isFavorite {
                return .send(.addFavorite(state.animal, state.photos[index]))
            } else {
                return .send(.removeFavorite(state.animal, state.photos[index]))
            }
            
        case .getPhotosResponse(.success(let data)):
            state.totalPhotos = data?.totalResults ?? 0
            state.title = "\(state.animal) (\(data?.totalResults ?? 0) Photos)"
            state.photos += data?.photos?.filter {
                !state.photos.contains($0)
            } ?? []
            state.viewState = .success(empty: state.totalPhotos == 0)
            if let nextPage = data?.nextPage {
                state.nextPage = nextPage
                state.requestParameter?.nextPage += 1
            }
            
            return .send(.getFavorites)
            
        case .getPhotosResponse(.failure(let error)):
            state.errorMessage = error.localizedDescription
            
        default:
            return .none
            
        }
        
        return .none
        
    }
}
