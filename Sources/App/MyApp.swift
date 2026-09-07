//
//  MyApp.swift
//  my-app
//
//  Created by Thanh Than on 04/09/2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    static let store = Store(initialState: AppCoordinatorState()) {
        AppCoordinator()
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(store: MyApp.store)
                .appLaunchSplash {
                    SystemSplashLogo()
                }
        }
    }
}
