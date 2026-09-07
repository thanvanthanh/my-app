//
//  UserRepository.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public final class UserRepository: UserRepositoryProtocol {
    private let api: BaseAPI<APIRouter>

    public init(api: BaseAPI<APIRouter> = BaseAPI<APIRouter>()) {
        self.api = api
    }

    public func searchUsers(query: String) async throws -> [User] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let response: ItemSearchResponseDTO = try await api.fetchDataAsync(target: .search(username: trimmed))
        return response.items?.map { $0.toDomain() } ?? []
    }
}
