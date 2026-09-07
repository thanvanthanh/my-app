//
//  AppEnvironment.swift
//  my-app
//
//  Created by Thanh Than on 07/09/2026.
//

import Foundation

public enum AppEnvironment: String, CaseIterable, Sendable {
    case debug = "Debug"
    case beta = "Beta"
    case adhoc = "Adhoc"
    case release = "Release"

    /// Base URL for API requests
    public var baseURL: String {
        return "https://" //"https://\(hostName)"
    }

    /// API Hostname
    public var hostName: String {
        switch self {
        case .debug, .beta:
            return "api.github.com"
        case .adhoc, .release:
            return "api.github.com"
        }
    }

    /// Whether detailed network and debug logging is enabled
    public var isLoggingEnabled: Bool {
        switch self {
        case .debug, .beta:
            return true
        case .adhoc, .release:
            return false
        }
    }

    /// Detect current environment from Info.plist (ProjectEnvironment key) or compiler flag fallback
    public static var current: AppEnvironment {
        if let envString = Bundle.main.object(forInfoDictionaryKey: "ProjectEnvironment") as? String,
           let env = AppEnvironment(rawValue: envString) {
            return env
        }
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
}

// Backward compatibility alias for the old misspelled name
public typealias Enviroment = AppEnvironment
