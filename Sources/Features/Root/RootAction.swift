//
//  RootAction.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

extension RouterAction: @unchecked @retroactive Sendable {}

@CasePathable
enum RootAction: Sendable {
    case router(IndexedRouterActionOf<Screen>)
}


