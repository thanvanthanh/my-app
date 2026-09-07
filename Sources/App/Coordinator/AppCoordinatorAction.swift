//
//  AppCoordinatorAction.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

extension RouterAction: @unchecked @retroactive Sendable {}

@CasePathable
enum AppCoordinatorAction: Sendable {
    case router(IndexedRouterActionOf<Screen>)
}

typealias RootAction = AppCoordinatorAction
