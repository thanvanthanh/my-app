//
//  RootAction.swift
//  my-app
//
//  Created by Antigravity on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@CasePathable
enum RootAction: Sendable {
    case search(SearchAction)
    case path(StackActionOf<RootPath>)
}
