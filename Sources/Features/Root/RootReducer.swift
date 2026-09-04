//
//  RootReducer.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    typealias State = RootState
    typealias Action = RootAction

    var body: some ReducerOf<Self> {
        Scope(state: \.search, action: \.search) {
            SearchFeature()
        }

        Reduce { state, action in
            switch action {
            case let .search(.delegate(.userSelected(user))):
                state.path.append(.detail(DetailState(user: user)))
                return .none

            case .search, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
