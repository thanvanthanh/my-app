//
//  TargetType.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation
import Alamofire

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestType: Equatable, Sendable {
    /// A request with endpoint path
    case requestPath(path: String)

    /// A request with query param appended to path
    case queryParameters(query: String)
}

public enum HTTPTask: @unchecked Sendable {
    /// A request with no body or query parameters.
    case requestPlain

    /// A request with URL-encoded parameters (suitable for GET query params).
    case requestParameters(parameters: [String: Any & Sendable], encoding: URLEncoding = .default)

    /// A request with JSON body encoded from dictionary.
    case requestJSONParameters(parameters: [String: Any & Sendable])

    /// A request with JSON body encoded from an Encodable model.
    case requestJSONEncodable(Encodable & Sendable)
}

public protocol TargetType: Sendable {
    var baseUrl: String { get }
    var path: RequestType { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: [String: String]? { get }
}
