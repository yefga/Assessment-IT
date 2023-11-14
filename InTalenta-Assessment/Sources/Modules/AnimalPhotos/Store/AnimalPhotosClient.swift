//
//  AnimalPhotosClient.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation
import ComposableArchitecture

struct RequestPhoto: Equatable {
    let perPage: Int = 10
    var query: String = ""
    var nextPage: Int = 1
}

struct EquatableVoid: Equatable {
    let errorMessage: String?
}

enum CoreDataResult: Equatable {
    case addSuccess
    case deleteSuccess
    case error(String)
}

struct PexelsAPIClient {
    var fetch: @Sendable (RequestPhoto?) async throws -> PexelsModel?
    var fetchDetail: @Sendable(String) async throws -> PhotoModel?
    var addFavorite: @Sendable(String, PhotoModel) async throws -> CoreDataResult
    var removeFavorite: @Sendable(String, Int) async throws -> CoreDataResult
    var fetchFavorite: @Sendable(String) async throws -> [String]
    var fetchAll: @Sendable() async throws -> [AnimalDBModel]
}

extension PexelsAPIClient: DependencyKey {
    static var liveValue = PexelsAPIClient (
        fetch: { params in
            var urlString = "https://api.pexels.com/v1/search"
            var components = URLComponents(string: urlString)!
            components.queryItems = [
                URLQueryItem(name: "query", value: params?.query),
                URLQueryItem(name: "page", value: String(params?.nextPage ?? 0)),
                URLQueryItem(name: "per_page", value: String(params?.perPage ?? 0)),
            ]
            var urlRequest = URLRequest(url: components.url!)
            urlRequest.setValue("0c7m7hmS8KmPCDjDJnA4IVLyoVcclJgdmAOjRmGLcuOnJMXBxOmF0h2d",
                                forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode(PexelsModel.self, from: data)
        },
        fetchDetail: { photoID in
            let urlString = "https://api.pexels.com/v1/photos/\(photoID)"
            var components = URLComponents(string: urlString)!
            var urlRequest = URLRequest(url: components.url!)
            urlRequest.setValue("0c7m7hmS8KmPCDjDJnA4IVLyoVcclJgdmAOjRmGLcuOnJMXBxOmF0h2d",
                                forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode(PhotoModel.self, from: data)
        },
        addFavorite: { animal, photo in
            let data = AnimalDB(using: CoreDataStack.shared.viewContext)
            data.category = animal
            data.photoID = String(photo.id ?? 0)
            data.photoThumbnail = photo.src?.tiny
            data.photoOriginal = photo.src?.original
            data.name = photo.alt
            do {
                try await  CoreDataStack.shared.createObject()
                return .addSuccess
            } catch  {
                return .error(error.localizedDescription)
            }
        
        },
        removeFavorite: { animal, photoID in
            do {
                if let model = try await CoreDataStack.shared.filterObjects(AnimalDB.self,
                                                                            entityName: "AnimalDB",
                                                                            attributeName: "category",
                                                                            attributeValue: animal)
                    .first(where: { 
                        Int($0.photoID ?? "0") == photoID
                    }) {
                    try await  CoreDataStack.shared.deleteObject(model)
                }

                return .deleteSuccess
            } catch {
                return .error(error.localizedDescription)
            }
        },
        fetchFavorite: { animal in
            let fetch = try await CoreDataStack.shared.filterObjects(AnimalDB.self,
                                                              entityName: "AnimalDB",
                                                              attributeName: "category",
                                                              attributeValue: animal)
            return fetch.map {
                $0.photoID ?? ""
            }
        },
        fetchAll: {
            return try await CoreDataStack.shared.readObject(AnimalDB.self, entityName: "AnimalDB").map {
                AnimalDBModel(db: $0)
            }
        }
    )
}

extension DependencyValues {
    var getPhotos: PexelsAPIClient {
      get { self[PexelsAPIClient.self] }
      set { self[PexelsAPIClient.self] = newValue }
    }
}
