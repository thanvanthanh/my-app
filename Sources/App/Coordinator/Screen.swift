//
//  Screen.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation
import ComposableArchitecture

@Reducer
enum Screen {
    case search(SearchFeature)
    case detail(DetailFeature)
}

extension Screen.State: Hashable, Sendable {}
