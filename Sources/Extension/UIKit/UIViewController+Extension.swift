//
//  UIViewController+Extension.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit

extension UIViewController {
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return UIViewController()
        }
        return rootVC
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            let xibName = String(describing: T.self)
            return T.init(nibName: xibName, bundle: nil)
        }
        
        return instantiateFromNib()
    }
        
    static func getNavigationViewController() -> UINavigationController {
        let viewController = self.loadFromNib()
        return UINavigationController.init(rootViewController: viewController)
    }
}
