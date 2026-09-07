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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    static let store = Store(initialState: RootState()) {
        RootFeature()
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: MyApp.store)
        }
    }
}
