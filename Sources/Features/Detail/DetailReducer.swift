//
//  DetailReducer.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import Foundation
import UIKit
import ComposableArchitecture

@Reducer
struct DetailFeature {
    typealias State = DetailState
    typealias Action = DetailAction

    @Dependency(\.openURL) var openURL

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openProfileButtonTapped:
                let url = state.user.htmlUrl
                return .run { _ in
                    await openURL(url)
                }
            }
        }
    }
}
