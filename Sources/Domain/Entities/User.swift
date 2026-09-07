//
//  User.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public struct User: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let username: String
    public let avatarURL: URL?
    public let profileURL: URL

    public init(
        id: Int,
        username: String,
        avatarURL: URL? = nil,
        profileURL: URL = URL(string: "https://github.com")!
    ) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.profileURL = profileURL
    }

    /// Convenience initializer for backward compatibility with SearchModel
    public init(
        id: Int,
        avatarUrl: String,
        htmlUrl: URL,
        login: String
    ) {
        self.id = id
        self.username = login
        self.avatarURL = URL(string: avatarUrl)
        self.profileURL = htmlUrl
    }

    // Convenience properties for Presentation Layer
    public var login: String { username }
    public var avatarUrl: String { avatarURL?.absoluteString ?? "" }
    public var htmlUrl: URL { profileURL }
}

// Backward compatibility alias
public typealias SearchModel = User
