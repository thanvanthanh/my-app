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
           error.code == NSURLErrorTimedOut || error.code == NSURLErrorUnknown {
            return true
        }
        return false
    }

    var isNotConnectedToInternet: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorDataNotAllowed {
            return true
        }
        return false
    }
}
