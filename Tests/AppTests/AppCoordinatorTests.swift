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
    func initialRoutesAreConfiguredWithWelcome() async {
        let store = TestStore(initialState: AppCoordinatorState()) {
            AppCoordinator()
        }

        #expect(store.state.routes == [.root(.welcome(WelcomeFeature.State()), withNavigation: true)])
    }

    @Test
    func welcomeContinuesToSearch() async {
        let store = TestStore(initialState: AppCoordinatorState()) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 0, action: .welcome(.delegate(.continueToApp))))) {
            $0.routes = [.root(.search(SearchState()), withNavigation: true)]
        }
    }

    @Test
    func welcomeSignInPushesLogin() async {
        let store = TestStore(initialState: AppCoordinatorState()) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 0, action: .welcome(.delegate(.showLogin))))) {
            $0.routes.push(.login(LoginFeature.State()))
        }
    }

    @Test
    func loginBackReturnsToWelcome() async {
        var initialState = AppCoordinatorState()
        initialState.routes.push(.login(LoginFeature.State()))
        let store = TestStore(initialState: initialState) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 1, action: .login(.delegate(.dismiss))))) {
            $0.routes.pop()
        }
    }

    @Test
    func successfulLoginContinuesToSearch() async {
        var initialState = AppCoordinatorState()
        initialState.routes.push(.login(LoginFeature.State()))
        let store = TestStore(initialState: initialState) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 1, action: .login(.delegate(.signedIn))))) {
            $0.routes = [.root(.search(SearchState()), withNavigation: true)]
        }
    }

    @Test
    func userSelectionPushesDetailScreen() async {
        let user = SearchModel(
            id: 1,
            avatarUrl: "https://avatar.com/1",
            htmlUrl: URL(string: "https://github.com/thanhthan")!,
            login: "thanhthan"
        )

        var initialState = AppCoordinatorState()
        initialState.routes = [.root(.search(SearchState()), withNavigation: true)]
        let store = TestStore(initialState: initialState) {
            AppCoordinator()
        }

        await store.send(.router(.routeAction(id: 0, action: .search(.delegate(.userSelected(user)))))) {
            $0.routes.push(.detail(DetailState(user: user)))
        }

        #expect(store.state.routes.count == 2)
    }
}
