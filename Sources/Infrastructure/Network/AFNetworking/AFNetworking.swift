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
        return AFNetworking(
            interceptor: RequestInterceptor(),
            eventMonitors: [AlamofireLogger()]
        )
    }()

    public private(set) var isNetworkReachable = true
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: Configs.share.env.hostName)

    public func listenForReachability() {
        guard let reachabilityManager else { return }
        isNetworkReachable = reachabilityManager.isReachable

        reachabilityManager.startListening { [weak self] status in
            guard let self else { return }
            switch status {
            case .notReachable:
                self.isNetworkReachable = false
            case .unknown, .reachable:
                self.isNetworkReachable = true
            }
        }
    }
}
