//
//  AppCoordinatorTests.swift
//  my-appTests
//
//  Created by Thanh Than on 07/09/2026.
//

import Testing
import Foundation
import ComposableArchitecture
import TCACoordinators
@testable import my_app

@MainActor
struct AppCoordinatorTests {

    @Test
    func initialRoutesAreConfiguredWithSearch() async {
        let store = TestStore(initialState: AppCoordinatorState()) {
            AppCoordinator()
        }

        #expect(store.state.routes == [.root(.search(SearchState()), withNavigation: true)])
    }

    @Test
    func userSelectionPushesDetailScreen() async {
        let user = SearchModel(
            id: 1,
            avatarUrl: "https://avatar.com/1",
            htmlUrl: URL(string: "https://github.com/thanhthan")!,
            login: "thanhthan"
        )

        let store = TestStore(initialState: AppCoordinatorState()) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 0, action: .search(.delegate(.userSelected(user)))))) {
            $0.routes.push(.detail(DetailState(user: user)))
        }

        #expect(store.state.routes.count == 2)
    }
}
