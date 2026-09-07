//
//  DetailState.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@ObservableState
struct DetailState: Equatable, Hashable, Sendable {
    let user: SearchModel
}
