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
        let profile = htmlUrl.flatMap { URL(string: $0) } ?? URL(string: "https://github.com/\(login)")!
        return User(
            id: id,
            username: login,
            avatarURL: avatar,
            profileURL: profile
        )
    }
}
