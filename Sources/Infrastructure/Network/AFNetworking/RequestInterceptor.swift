//
//  RequestInterceptor.swift
//  my-app
//
//  Created by Thân Văn Thanh on 31/08/2023.
//

import Foundation
import Alamofire

private actor RefreshTokenCoordinator {
    private var isRefreshing = false
    private var waiters: [CheckedContinuation<Bool, Never>] = []

    func requestRefresh() async -> Bool {
        if isRefreshing {
            // Queue request and await outcome of the existing refresh operation
            return await withCheckedContinuation { continuation in
                waiters.append(continuation)
            }
        } else {
            isRefreshing = true
            return true
        }
    }

    func finishRefresh(success: Bool) {
        isRefreshing = false
        for waiter in waiters {
            waiter.resume(returning: success)
        }
        waiters.removeAll()
    }
}

private struct SendableCompletion: @unchecked Sendable {
    let handler: (RetryResult) -> Void

    func callAsFunction(_ result: RetryResult) {
        handler(result)
    }
}

public final class RequestInterceptor: Alamofire.RequestInterceptor, @unchecked Sendable {
    private let coordinator = RefreshTokenCoordinator()

    public init() {}

    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        completion(.success(urlRequest))
    }

    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        let sendableCompletion = SendableCompletion(handler: completion)
        _Concurrency.Task {
            let shouldPerform = await coordinator.requestRefresh()
            if shouldPerform {
                let success = await self.executeTokenRefresh()
                await coordinator.finishRefresh(success: success)
                sendableCompletion(success ? .retry : .doNotRetry)
            } else {
                // Was queued while another request refreshed
                sendableCompletion(.retry)
            }
        }
    }

    private func executeTokenRefresh() async -> Bool {
        // Implement token refresh call here (e.g. call auth refresh API)
        // If successful, update tokens and return true
        return false
    }
}
