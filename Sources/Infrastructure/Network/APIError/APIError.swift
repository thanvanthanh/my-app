//
//  APIError.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public enum APIError: LocalizedError, Equatable, Sendable {
    case general
    case timeout
    case notFound
    case noNetwork
    case serverError(statusCode: Int)
    case serverMessage(String)
    case decodingError(String)

    public var errorDescription: String? {
        switch self {
        case .general:
            return "Đã có lỗi xảy ra. Vui lòng thử lại sau."
        case .timeout:
            return "Kết nối quá thời gian chờ (Timeout)."
        case .notFound:
            return "Không tìm thấy dữ liệu yêu cầu."
        case .noNetwork:
            return "Không có kết nối mạng. Vui lòng kiểm tra lại đường truyền."
        case let .serverError(statusCode):
            return "Lỗi máy chủ (\(statusCode))."
        case let .serverMessage(message):
            return message
        case let .decodingError(error):
            return "Lỗi xử lý dữ liệu: \(error)"
        }
    }
}
