//
//  RootState.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@ObservableState
struct RootState: Equatable, Sendable {
    var routes: [Route<Screen.State>] = [.root(.search(SearchState()), withNavigation: true)]
}

