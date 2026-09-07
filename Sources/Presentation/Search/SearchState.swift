//
//  SearchState.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@ObservableState
struct SearchState: Equatable, Hashable, Sendable {
    var query: String = "thanvanthanh"
    var users: [SearchModel] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var isListEmpty: Bool {
        !isLoading && users.isEmpty && errorMessage == nil
    }
}
