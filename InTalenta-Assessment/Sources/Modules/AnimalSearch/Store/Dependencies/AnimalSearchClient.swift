//
//  AnimalSearchClient.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 09/11/23.
//

import Foundation
import ComposableArchitecture

struct NinjaAPIClient {
    
    var search: @Sendable (String) async throws -> [AnimalDataModel]?

}

extension NinjaAPIClient: DependencyKey {
    static var liveValue = NinjaAPIClient (
        search: { keyword in
            var components = URLComponents(string: "https://api.api-ninjas.com/v1/animals")!
            components.queryItems = [
                URLQueryItem(name: "name", value: keyword)
            ]
            var urlRequest = URLRequest(url: components.url!)
            urlRequest.setValue("e0vk3ZUxeQlxKo6aZHcRBw==1ZemwuP5IIdm4Lfs", forHTTPHeaderField: "X-Api-Key")
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode([AnimalDataModel].self, from: data)
        }
    )
}

extension NinjaAPIClient: TestDependencyKey {
  static let previewValue = Self(
    search: { _ in [.mock()] }
  )

  static let testValue = Self(
    search: unimplemented("\(Self.self).search")
  )
}

extension DependencyValues {
    var searchAnimal: NinjaAPIClient {
      get { self[NinjaAPIClient.self] }
      set { self[NinjaAPIClient.self] = newValue }
    }
}
