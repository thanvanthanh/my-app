//
//  UserDTOTests.swift
//  my-appTests
//
//  Created by Thanh Than on 07/09/2026.
//

import Testing
import Foundation
@testable import my_app

struct UserDTOTests {

    @Test
    func userDTODecodingAndDomainMapping() throws {
        let json = """
        {
            "id": 1337,
            "login": "octocat",
            "avatar_url": "https://avatars.githubusercontent.com/u/1337?v=4",
            "html_url": "https://github.com/octocat"
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(UserDTO.self, from: json)
        #expect(dto.id == 1337)
        #expect(dto.login == "octocat")

        let domainUser = dto.toDomain()
        #expect(domainUser.id == 1337)
        #expect(domainUser.username == "octocat")
        #expect(domainUser.avatarURL == URL(string: "https://avatars.githubusercontent.com/u/1337?v=4"))
        #expect(domainUser.profileURL == URL(string: "https://github.com/octocat"))
    }
}
