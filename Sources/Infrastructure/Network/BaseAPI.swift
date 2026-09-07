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
    public init() {}

    open func fetchDataAsync<M: Decodable & Sendable>(
        target: T,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> M {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.header ?? [:])
        let targetPath = buildTarget(target: target.path)
        let url = target.baseUrl + targetPath

        let request: DataRequest
        switch target.task {
        case .requestPlain:
            request = AFNetworking.shared.request(
                url,
                method: method,
                headers: headers,
                requestModifier: { $0.timeoutInterval = 20 }
            )
        case let .requestParameters(parameters, encoding):
            request = AFNetworking.shared.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers,
                requestModifier: { $0.timeoutInterval = 20 }
            )
        case let .requestJSONParameters(parameters):
            request = AFNetworking.shared.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers,
                requestModifier: { $0.timeoutInterval = 20 }
            )
        case let .requestJSONEncodable(encodable):
            request = AFNetworking.shared.request(
                url,
                method: method,
                parameters: encodable,
                encoder: JSONParameterEncoder.default,
                headers: headers,
                requestModifier: { $0.timeoutInterval = 20 }
            )
        }

        let validatedRequest = request.validate(statusCode: 200..<300)

        do {
            return try await validatedRequest
                .serializingDecodable(M.self, decoder: decoder)
                .value
        } catch let afError as AFError {
            // Check if server returned a JSON error response with custom message
            if let data = await request.serializingData().response.data,
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
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError.localizedDescription)
        } catch {
            throw APIError.general
        }
    }

    private func buildTarget(target: RequestType) -> String {
        switch target {
        case let .requestPath(path):
            return path
        case let .queryParameters(query):
            return query
        }
    }
}
