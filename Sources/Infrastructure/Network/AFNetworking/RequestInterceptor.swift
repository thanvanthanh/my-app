//
//  RequestInterceptor.swift
//  my-app
//
//  Created by Thân Văn Thanh on 31/08/2023.
//

import Foundation
import Alamofire

actor RefreshTokenCoordinator {
    private var refreshTask: Task<Bool, Never>?

    func refresh(using operation: @escaping @Sendable () async -> Bool) async -> Bool {
        if let refreshTask {
            return await refreshTask.value
        }

        let task = Task { await operation() }
        refreshTask = task
        let succeeded = await task.value
        refreshTask = nil
        return succeeded
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
    private let refreshOperation: @Sendable () async -> Bool

    public init(refreshOperation: @escaping @Sendable () async -> Bool = { false }) {
        self.refreshOperation = refreshOperation
    }

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
        guard let response = request.response,
              response.statusCode == 401,
              request.retryCount == 0 else {
            completion(.doNotRetry)
            return
        }

        let sendableCompletion = SendableCompletion(handler: completion)
        _Concurrency.Task {
            let success = await coordinator.refresh(using: refreshOperation)
            sendableCompletion(success ? .retry : .doNotRetry)
        }
    }
}
