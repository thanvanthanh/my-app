//
//  SearchClient.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct SearchClient: Sendable {
    var search: @Sendable (_ query: String) async throws -> [SearchModel]
}

extension DependencyValues {
    var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}

extension SearchClient: DependencyKey {
    static let liveValue = Self(
        search: { query in
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return [] }
            let api = BaseAPI<APIRouter>()
            let response: ItemSearchResponse = try await api.fetchDataAsync(target: .search(username: trimmed))
            return response.items ?? []
        }
    )

    static let testValue = Self(
        search: { _ in
            [
                SearchModel(
                    id: 1,
                    avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
                    htmlUrl: URL(string: "https://github.com/mojombo")!,
                    login: "mojombo"
                ),
                SearchModel(
                    id: 2,
                    avatarUrl: "https://avatars.githubusercontent.com/u/2?v=4",
                    htmlUrl: URL(string: "https://github.com/defunkt")!,
                    login: "defunkt"
                )
            ]
        }
    )
}
