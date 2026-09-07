//
//  AppCoordinatorView.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .welcome(welcomeStore):
                WelcomeView(store: welcomeStore)
            case let .login(loginStore):
                LoginView(store: loginStore)
            case let .search(searchStore):
                SearchView(store: searchStore)
            case let .detail(detailStore):
                DetailView(store: detailStore)
            }
        }
    }
}

typealias RootView = AppCoordinatorView
