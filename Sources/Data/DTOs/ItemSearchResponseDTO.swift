//
//  ItemSearchResponseDTO.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public struct ItemSearchResponseDTO: Codable, Sendable {
    public let totalCount: Int?
    public let items: [UserDTO]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
