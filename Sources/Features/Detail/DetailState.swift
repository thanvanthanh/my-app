//
//  DetailState.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@ObservableState
struct DetailState: Equatable, Sendable {
    let user: SearchModel
}
