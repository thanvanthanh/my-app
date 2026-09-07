//
//  ConfigsTests.swift
//  my-appTests
//
//  Created by Thanh Than on 07/09/2026.
//

import Testing
import Foundation
@testable import my_app

struct ConfigsTests {

    @Test
    func appEnvironmentBaseURLAndHostName() {
        let debugEnv = AppEnvironment.debug
        #expect(debugEnv.baseURL == "https://api.github.com")
        #expect(debugEnv.hostName == "api.github.com")
        #expect(debugEnv.isLoggingEnabled == true)

        let releaseEnv = AppEnvironment.release
        #expect(releaseEnv.baseURL == "https://api.github.com")
        #expect(releaseEnv.isLoggingEnabled == false)
    }

    @Test
    func configsDefaultProperties() {
        let configs = Configs.shared
        #expect(!configs.appVersion.isEmpty)
        #expect(!configs.buildVersion.isEmpty)
        #expect(!configs.bundleIdentifier.isEmpty)
        #expect(!configs.appName.isEmpty)
        #expect(configs.networkTimeoutInterval == 20)
    }

    @Test
    func customConfigsInitialization() {
        let custom = Configs(env: .beta, networkTimeoutInterval: 15)
        #expect(custom.env == .beta)
        #expect(custom.networkTimeoutInterval == 15)
    }
}
