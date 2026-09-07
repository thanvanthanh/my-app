//
//  RequestInterceptor.swift
//  my-app
//
//  Created by Thân Văn Thanh on 31/08/2023.
//

import Foundation
import Alamofire

protocol RefreshTokenRequestable: AnyObject {
    func refreshToken(_ token: String) async throws -> AuthorizeModel?
}

final class RefreshTokenRequest: BaseAPI<APIRouter>, RefreshTokenRequestable {
    func refreshToken(_ token: String) async throws -> AuthorizeModel? {
        try await self.fetchDataAsync(target: .refreshToken(token: token))
    }
}

final class RequestInterceptor: Alamofire.RequestInterceptor, @unchecked Sendable {
    
    private let refreshUseCase: RefreshTokenRequest
    
    @Atomic private var isRefreshing = false
    
    init(refreshUseCase: RefreshTokenRequest = RefreshTokenRequest(),
         isRefreshing: Bool = false) {
        self.refreshUseCase = refreshUseCase
        self.isRefreshing = isRefreshing
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.response,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        if !isRefreshing {
            isRefreshing = true
            _Concurrency.Task {
                await refreshToken()
            }
        }
    }
    
    private func refreshToken() async {
        defer { isRefreshing = false }
        do {
            let data = try await refreshUseCase.refreshToken("")
            if let data = data {
                print("Token refreshed: \(data)")
            }
        } catch {
            print("Token refresh failed: \(error)")
        }
    }
}

