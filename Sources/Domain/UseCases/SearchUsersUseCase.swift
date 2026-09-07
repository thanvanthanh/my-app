//
//  SearchUsersUseCase.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation
import ComposableArchitecture

@DependencyClient
public struct SearchUsersUseCase: Sendable {
    public var execute: @Sendable (_ query: String) async throws -> [User]
}

extension DependencyValues {
    public var searchUsersUseCase: SearchUsersUseCase {
        get { self[SearchUsersUseCase.self] }
        set { self[SearchUsersUseCase.self] = newValue }
    }
}

extension SearchUsersUseCase: DependencyKey {
    public static let liveValue = Self(
        execute: { query in
            let repository = UserRepository()
            return try await repository.searchUsers(query: query)
        }
    )

    public static let testValue = Self()
}
