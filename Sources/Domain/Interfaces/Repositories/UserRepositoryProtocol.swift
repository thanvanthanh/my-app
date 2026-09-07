//
//  UserRepositoryProtocol.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public protocol UserRepositoryProtocol: Sendable {
    func searchUsers(query: String) async throws -> [User]
}
