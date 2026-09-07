//
//  Configs.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public struct Configs: Sendable {
    /// Shared singleton instance
    public static let shared = Configs()

    /// Backward compatibility alias for `.share`
    public static var share: Configs { shared }

    /// Current application environment (Debug, Beta, Adhoc, Release)
    public let env: AppEnvironment

    /// Application version string (e.g. "2.0.0")
    public let appVersion: String

    /// Application build number (e.g. "1")
    public let buildVersion: String

    /// Application bundle identifier
    public let bundleIdentifier: String

    /// Application display name
    public let appName: String

    /// Default timeout interval for network requests (seconds)
    public let networkTimeoutInterval: TimeInterval

    public init(
        env: AppEnvironment = .current,
        bundle: Bundle = .main,
        networkTimeoutInterval: TimeInterval = 20
    ) {
        self.env = env
        self.appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        self.buildVersion = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        self.bundleIdentifier = bundle.bundleIdentifier ?? "com.thanhthan.app"
        self.appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "my-app"
        self.networkTimeoutInterval = networkTimeoutInterval
    }
}
