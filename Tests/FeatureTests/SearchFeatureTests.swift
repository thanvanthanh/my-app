//
//  SearchFeatureTests.swift
//  my-appTests
//
//  Created by Thanh Than on 07/09/2026.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import my_app

@MainActor
struct SearchFeatureTests {

    @Test
    func queryChangedAndDebounceSearchSuccess() async {
        let clock = TestClock()
        let mockUsers = [
            SearchModel(
                id: 1,
                avatarUrl: "https://avatar.com/1",
                htmlUrl: URL(string: "https://github.com/thanhthan")!,
                login: "thanhthan"
            )
        ]

        let store = TestStore(initialState: SearchState()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.searchUsersUseCase.execute = { query in
                #expect(query == "thanh")
                return mockUsers
            }
        }

        // 1. User types query
        await store.send(.queryChanged("thanh")) {
            $0.query = "thanh"
        }

        // 2. Advance clock through 400ms debounce
        await clock.advance(by: .milliseconds(400))

        // 3. Search debounced triggers performSearch
        await store.receive(\.searchDebounced) {
            $0.isLoading = true
            $0.errorMessage = nil
        }

        // 4. API returns results
        await store.receive(\.searchResponse.success) {
            $0.isLoading = false
            $0.users = mockUsers
            $0.errorMessage = nil
        }
    }

    @Test
    func queryClearedResetsStateAndCancelsSearch() async {
        let mockUsers = [
            SearchModel(
                id: 1,
                avatarUrl: "https://avatar.com/1",
                htmlUrl: URL(string: "https://github.com/thanhthan")!,
                login: "thanhthan"
            )
        ]

        let store = TestStore(initialState: SearchState(query: "thanh", users: mockUsers)) {
            SearchFeature()
        }

        await store.send(.queryChanged("")) {
            $0.query = ""
            $0.users = []
            $0.errorMessage = nil
            $0.isLoading = false
        }
    }

    @Test
    func searchFailureDisplaysErrorMessage() async {
        let clock = TestClock()

        let store = TestStore(initialState: SearchState()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.searchUsersUseCase.execute = { _ in
                throw SearchAction.SearchError.message("Internet connection offline")
            }
        }

        await store.send(.queryChanged("error_query")) {
            $0.query = "error_query"
        }

        await clock.advance(by: .milliseconds(400))

        await store.receive(\.searchDebounced) {
            $0.isLoading = true
            $0.errorMessage = nil
        }

        await store.receive(\.searchResponse.failure) {
            $0.isLoading = false
            $0.errorMessage = "Internet connection offline"
        }
    }

    @Test
    func userTappedEmitsDelegateAction() async {
        let user = SearchModel(
            id: 1,
            avatarUrl: "https://avatar.com/1",
            htmlUrl: URL(string: "https://github.com/thanhthan")!,
            login: "thanhthan"
        )

        let store = TestStore(initialState: SearchState()) {
            SearchFeature()
        }

        await store.send(.userTapped(user))
        await store.receive(.delegate(.userSelected(user)))
    }

    @Test
    func submittingSearchCancelsPendingDebounce() async {
        let clock = TestClock()
        let calls = LockIsolated(0)

        let store = TestStore(initialState: SearchState()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.searchUsersUseCase.execute = { _ in
                calls.withValue { $0 += 1 }
                return []
            }
        }

        await store.send(.queryChanged("octocat")) {
            $0.query = "octocat"
        }
        await store.send(.searchSubmitted) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        await store.receive(\.searchResponse.success) {
            $0.isLoading = false
            $0.users = []
            $0.errorMessage = nil
        }

        await clock.advance(by: .milliseconds(400))
        #expect(calls.value == 1)
    }
}
