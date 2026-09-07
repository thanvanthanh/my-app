//
//  AlamofireLogger.swift
//  my-app
//
//  Created by Thân Văn Thanh on 29/08/2023.
//

import Foundation
import Alamofire

public final class AlamofireLogger: EventMonitor, @unchecked Sendable {
    private static let sensitiveHeaderNames: Set<String> = [
        "authorization", "cookie", "set-cookie", "x-api-key"
    ]
    private static let sensitiveQueryNames: Set<String> = [
        "access_token", "api_key", "authorization", "refresh_token", "token"
    ]
    private let isEnabled: Bool

    public init(isEnabled: Bool = false) {
        self.isEnabled = isEnabled
    }

    public func requestDidResume(_ request: Request) {
        guard isEnabled else { return }
        let headers = redactedHeaders(request.request?.allHTTPHeaderFields)
        let bodySize = request.request?.httpBody?.count ?? 0
        let url = redactedURL(request.request?.url)
        let message = """
        \n┌🚀🚀🚀🚀🚀
        | Request Started: \(request.request?.httpMethod ?? "") \(url)
        | Body Size: \(bodySize) bytes
        | Headers: \(headers)
        └🚀🚀🚀🚀🚀
        """
        NSLog(message)
    }

    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard isEnabled else { return }
        switch response.result {
        case .success:
            if let body = response.data {
                NSLog("\n┌✅✅✅✅✅\n| Response URL: \(redactedURL(response.request?.url))\n| Body Size: \(body.count) bytes\n└✅✅✅✅✅")
            }
        case let .failure(error):
            logError(
                error: error,
                statusCode: response.response?.statusCode ?? 0,
                method: response.request?.method?.rawValue ?? "",
                url: redactedURL(response.request?.url)
            )
        }
    }

    private func redactedHeaders(_ headers: [String: String]?) -> String {
        guard let headers else { return "[:]" }
        return headers.map { key, value in
            Self.sensitiveHeaderNames.contains(key.lowercased()) ? "\(key): <redacted>" : "\(key): \(value)"
        }.sorted().joined(separator: ", ")
    }

    private func redactedURL(_ url: URL?) -> String {
        guard let url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return ""
        }
        components.queryItems = components.queryItems?.map { item in
            Self.sensitiveQueryNames.contains(item.name.lowercased())
                ? URLQueryItem(name: item.name, value: "<redacted>")
                : item
        }
        return components.string ?? ""
    }

    private func logError(error: AFError, statusCode: Int, method: String, url: String) {
        NSLog("""
        \n┌❌❌❌❌❌
        | Endpoint: \(method) \(url)
        | Status Code: \(statusCode)
        | Error: request failed (response code: \(error.responseCode.map(String.init) ?? "none"))
        └❌❌❌❌❌
        """)
    }
}
