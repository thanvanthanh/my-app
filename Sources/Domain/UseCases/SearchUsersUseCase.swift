//
//  SearchUsersUseCase.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public struct SearchUsersUseCase: Sendable {
    public var execute: @Sendable (_ query: String) async throws -> [User]

    public init(
        execute: @escaping @Sendable (_ query: String) async throws -> [User]
    ) {
        self.execute = execute
    }

    public init(repository: any UserRepositoryProtocol) {
        self.init { query in
            try await repository.searchUsers(query: query)
        }
    }
}
