//
//  BaseAPI.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation
import Alamofire

public struct BackendErrorResponse: Decodable, Sendable {
    public let message: String?
    public let documentationUrl: String?

    enum CodingKeys: String, CodingKey {
        case message
        case documentationUrl = "documentation_url"
    }
}

open class BaseAPI<T: TargetType>: @unchecked Sendable {
    private let session: Alamofire.Session
    private let timeoutInterval: TimeInterval

    public init(
        session: Alamofire.Session = AFNetworking.shared,
        timeoutInterval: TimeInterval = Configs.shared.networkTimeoutInterval
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
    }

    open func fetchDataAsync<M: Decodable & Sendable>(
        target: T,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> M {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.header ?? [:])
        let url = try Self.buildURL(baseURL: target.baseUrl, request: target.path)
        let requestTimeoutInterval = timeoutInterval

        let request: DataRequest
        switch target.task {
        case .requestPlain:
            request = session.request(
                url,
                method: method,
                headers: headers,
                requestModifier: { $0.timeoutInterval = requestTimeoutInterval }
            )
        case let .requestParameters(parameters, encoding):
            request = session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers,
                requestModifier: { $0.timeoutInterval = requestTimeoutInterval }
            )
        case let .requestJSONParameters(parameters):
            request = session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers,
                requestModifier: { $0.timeoutInterval = requestTimeoutInterval }
            )
        case let .requestJSONEncodable(encodable):
            request = session.request(
                url,
                method: method,
                parameters: encodable,
                encoder: JSONParameterEncoder.default,
                headers: headers,
                requestModifier: { $0.timeoutInterval = requestTimeoutInterval }
            )
        }

        let validatedRequest = request.validate(statusCode: 200..<300)

        let response = await validatedRequest.serializingData().response
        switch response.result {
        case let .success(data):
            do {
                return try decoder.decode(M.self, from: data)
            } catch let decodingError as DecodingError {
                throw APIError.decodingError(decodingError.localizedDescription)
            } catch {
                throw APIError.general
            }

        case let .failure(afError):
            if afError.isCancelled {
                throw CancellationError()
            }

            if let data = response.data,
               let backendError = try? JSONDecoder().decode(BackendErrorResponse.self, from: data),
               let msg = backendError.message, !msg.isEmpty {
                throw APIError.serverMessage(msg)
            }

            if afError.isTimeout {
                throw APIError.timeout
            } else if afError.isNotConnectedToInternet {
                throw APIError.noNetwork
            } else if let statusCode = afError.responseCode {
                if statusCode == 404 {
                    throw APIError.notFound
                }
                throw APIError.serverError(statusCode: statusCode)
            } else {
                throw APIError.general
            }
        }
    }

    static func buildURL(baseURL: String, request: RequestType) throws -> URL {
        guard var components = URLComponents(string: baseURL),
              components.scheme?.lowercased() == "https",
              let host = components.host,
              !host.isEmpty else {
            throw APIError.general
        }

        switch request {
        case let .requestPath(path):
            let basePath = components.path.hasSuffix("/") ? String(components.path.dropLast()) : components.path
            let requestPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
            components.path = basePath + "/" + requestPath
        case let .queryParameters(query):
            components.percentEncodedQuery = query.hasPrefix("?") ? String(query.dropFirst()) : query
        }

        guard let url = components.url else {
            throw APIError.general
        }
        return url
    }
}
