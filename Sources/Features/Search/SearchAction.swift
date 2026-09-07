//
//  SearchAction.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import Foundation
import ComposableArchitecture

@CasePathable
enum SearchAction: Equatable, Sendable {
    // View actions
    case onAppear
    case queryChanged(String)
    case searchSubmitted
    case refreshTriggered
    case userTapped(SearchModel)
    
    // Internal actions
    case searchDebounced
    
    // Response actions
    case searchResponse(Result<[SearchModel], SearchError>)
    
    // Delegate actions (sent to parent/RootFeature)
    case delegate(Delegate)
    
    enum Delegate: Equatable, Sendable {
        case userSelected(SearchModel)
    }
    
    enum SearchError: LocalizedError, Equatable, Sendable {
        case message(String)
        
        var errorDescription: String? {
            switch self {
            case let .message(msg): return msg
            }
        }
    }
}
