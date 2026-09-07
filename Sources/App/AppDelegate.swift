//
//  AppDelegate.swift
//  mvvm-combine-uikit
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AFNetworking.shared.listenForReachability()
        return true
    }
}
