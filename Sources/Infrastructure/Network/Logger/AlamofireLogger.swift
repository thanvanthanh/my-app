//
//  AlamofireLogger.swift
//  my-app
//
//  Created by Thân Văn Thanh on 29/08/2023.
//

import Foundation
import Alamofire

public final class AlamofireLogger: EventMonitor, @unchecked Sendable {
    public init() {}

    public func requestDidResume(_ request: Request) {
        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields?.description } ?? ""
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "{}"
        let message = """
        \n┌🚀🚀🚀🚀🚀
        | Request Started: \(request)
        | Body Data: \(body)
        | Headers: \(allHeaders)
        └🚀🚀🚀🚀🚀
        """
        NSLog(message)
    }

    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        switch response.result {
        case .success:
            if let body = response.data {
                let bodyString = String(decoding: body, as: UTF8.self)
                NSLog("\n┌✅✅✅✅✅\n| Response URL: \(response.request?.url?.absoluteString ?? "")\n| Body: \(bodyString)\n└✅✅✅✅✅")
            }
        case let .failure(error):
            logError(
                error: error,
                statusCode: response.response?.statusCode ?? 0,
                method: response.request?.method?.rawValue ?? "",
                url: response.request?.url?.absoluteString ?? ""
            )
        }
    }

    private func logError(error: AFError, statusCode: Int, method: String, url: String) {
        NSLog("""
        \n┌❌❌❌❌❌
        | Endpoint: \(method) \(url)
        | Status Code: \(statusCode)
        | Error: \(error)
        └❌❌❌❌❌
        """)
    }
}
