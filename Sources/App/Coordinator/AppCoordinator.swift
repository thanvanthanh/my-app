//
//  AppCoordinator.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer
struct AppCoordinator {
    typealias State = AppCoordinatorState
    typealias Action = AppCoordinatorAction

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, .search(.delegate(.userSelected(user))))):
                state.routes.push(.detail(DetailState(user: user)))
                return .none

            case .router:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

typealias RootFeature = AppCoordinator
