//
//  UserDTO.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public struct UserDTO: Codable, Sendable {
    public let id: Int
    public let login: String
    public let avatarUrl: String?
    public let htmlUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }

    public func toDomain() -> User {
        let avatar = avatarUrl.flatMap { URL(string: $0) }
        let profile = validatedGitHubProfileURL ?? fallbackGitHubProfileURL
        return User(
            id: id,
            username: login,
            avatarURL: avatar,
            profileURL: profile
        )
    }

    private var validatedGitHubProfileURL: URL? {
        guard let htmlUrl,
              let url = URL(string: htmlUrl),
              url.scheme?.lowercased() == "https",
              let host = url.host?.lowercased(),
              host == "github.com" || host == "www.github.com" else {
            return nil
        }
        return url
    }

    private var fallbackGitHubProfileURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/\(login)"
        return components.url ?? URL(fileURLWithPath: "/")
    }
}
