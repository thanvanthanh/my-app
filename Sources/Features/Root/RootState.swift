//
//  RootState.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@ObservableState
struct RootState: Equatable, Sendable {
    var search = SearchState()
    var path = StackState<RootPath.State>()
}

@Reducer
enum RootPath {
    case detail(DetailFeature)
}

extension RootPath.State: Equatable, Sendable {}
