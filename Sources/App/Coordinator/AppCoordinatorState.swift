//
//  AppCoordinatorState.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@ObservableState
struct AppCoordinatorState: Equatable, Sendable {
    var routes: [Route<Screen.State>] = [
        .root(.welcome(WelcomeFeature.State()), withNavigation: true)
    ]
}

typealias RootState = AppCoordinatorState
