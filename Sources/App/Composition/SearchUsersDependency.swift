//
//  SearchUsersDependency.swift
//  my-app
//

import ComposableArchitecture

extension DependencyValues {
    var searchUsersUseCase: SearchUsersUseCase {
        get { self[SearchUsersUseCase.self] }
        set { self[SearchUsersUseCase.self] = newValue }
    }
}

extension SearchUsersUseCase: DependencyKey {
    public static let liveValue = SearchUsersUseCase(
        repository: UserRepository()
    )

    public static let testValue = SearchUsersUseCase { _ in [] }
}
