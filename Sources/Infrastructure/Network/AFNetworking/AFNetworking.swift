//
//  AFNetworking.swift
//  my-app
//
//  Created by Thân Văn Thanh on 29/08/2023.
//

import Alamofire
import Foundation

public final class AFNetworking: Alamofire.Session, @unchecked Sendable {
    public static let shared: AFNetworking = {
        let environment = Configs.shared.env
        return AFNetworking(
            interceptor: RequestInterceptor(),
            eventMonitors: [AlamofireLogger(isEnabled: environment.isLoggingEnabled)]
        )
    }()

    private let reachabilityLock = NSLock()
    private var networkReachable = true
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: Configs.share.env.hostName)

    public var isNetworkReachable: Bool {
        reachabilityLock.withLock { networkReachable }
    }

    public func listenForReachability() {
        guard let reachabilityManager else { return }
        reachabilityLock.withLock {
            networkReachable = reachabilityManager.isReachable
        }

        reachabilityManager.startListening { [weak self] status in
            guard let self else { return }
            self.reachabilityLock.withLock {
                switch status {
                case .notReachable:
                    self.networkReachable = false
                case .unknown, .reachable:
                    self.networkReachable = true
                }
            }
        }
    }
}
