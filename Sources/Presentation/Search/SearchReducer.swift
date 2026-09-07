//
//  SearchReducer.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature {
    typealias State = SearchState
    typealias Action = SearchAction

    @Dependency(\.searchUsersUseCase) var searchUsersUseCase
    @Dependency(\.continuousClock) var clock

    private enum CancelID {
        case search
        case debounce
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.users.isEmpty else { return .none }
                return performSearch(query: state.query, state: &state)

            case let .queryChanged(newQuery):
                state.query = newQuery
                let trimmed = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    state.users = []
                    state.errorMessage = nil
                    state.isLoading = false
                    return .merge(
                        .cancel(id: CancelID.search),
                        .cancel(id: CancelID.debounce)
                    )
                }

                // Debounce search with ContinuousClock
                return .run { send in
                    try await clock.sleep(for: .milliseconds(400))
                    await send(.searchDebounced)
                }
                .cancellable(id: CancelID.debounce, cancelInFlight: true)

            case .searchDebounced:
                return performSearch(query: state.query, state: &state)

            case .searchSubmitted, .refreshTriggered:
                return .merge(
                    .cancel(id: CancelID.debounce),
                    performSearch(query: state.query, state: &state)
                )

            case let .searchResponse(.success(users)):
                state.isLoading = false
                state.users = users
                state.errorMessage = nil
                return .none

            case let .searchResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case let .userTapped(user):
                return .send(.delegate(.userSelected(user)))

            case .delegate:
                return .none
            }
        }
    }

    private func performSearch(query: String, state: inout State) -> Effect<Action> {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state.users = []
            state.isLoading = false
            return .none
        }

        state.isLoading = true
        state.errorMessage = nil

        return .run { [query = trimmed] send in
            do {
                let users = try await searchUsersUseCase.execute(query)
                try Task.checkCancellation()
                await send(.searchResponse(.success(users)))
            } catch is CancellationError {
                return
            } catch {
                await send(.searchResponse(.failure(.message(error.localizedDescription))))
            }
        }
        .cancellable(id: CancelID.search, cancelInFlight: true)
    }
}
