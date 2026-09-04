//
//  AppDelegate.swift
//  mvvm-combine-uikit
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {

    private var bag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AFNetworking.shared.listenForReachability()
        
        // Leak Detector
        configLeakDetector()
        return true
    }
    
    private func configLeakDetector() {
        LeakDetector.instance.isEnabled = false
        
        LeakDetector.instance.status
            .sink(
                receiveValue: { status in
                    print("LeakDetector \(status)")
                }
            )
            .store(in: bag)
        
        LeakDetector.instance.isLeaked
            .sink { message in
                if let message = message {
                    print("LEAK \(message)")
                }
            }
            .store(in: bag)
        
    }

}
