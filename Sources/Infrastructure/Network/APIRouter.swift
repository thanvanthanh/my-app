//
//  APIRouter.swift
//  my-app
//
//  Created by Thân Văn Thanh on 28/08/2023.
//

import Foundation
import Alamofire

public enum APIRouter {
    case search(username: String)
    case refreshToken(token: String)
}

extension APIRouter: TargetType {
    public var baseUrl: String {
        return Configs.share.env.baseURL
    }

    public var path: RequestType {
        switch self {
        case .search:
            return .requestPath(path: "/search/users")
        case .refreshToken:
            return .requestPath(path: "/auth/refresh")
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .refreshToken:
            return .post
        }
    }

    public var task: HTTPTask {
        switch self {
        case let .search(username):
            return .requestParameters(parameters: ["q": username], encoding: .default)
        case let .refreshToken(token):
            return .requestJSONParameters(parameters: ["refresh_token": token])
        }
    }

    public var header: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
