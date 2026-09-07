//
//  AFError+Extension.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation
import Alamofire

extension AFError {
    var isTimeout: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.domain == NSURLErrorDomain,
           error.code == NSURLErrorTimedOut {
            return true
        }
        return false
    }

    var isNotConnectedToInternet: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.domain == NSURLErrorDomain,
           error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorDataNotAllowed {
            return true
        }
        return false
    }

    var isCancelled: Bool {
        if case .explicitlyCancelled = self {
            return true
        }
        guard isSessionTaskError, let error = underlyingError as NSError? else {
            return false
        }
        return error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled
    }
}
