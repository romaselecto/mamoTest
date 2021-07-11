//
//  Util.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import UIKit

let APP_DELEGATE                = UIApplication.shared.delegate as! AppDelegate

enum Utils {
    // MARK: - TOP VIEWCONTROLLER
    static func topViewController(base: UIViewController? = APP_DELEGATE.window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    // MARK: - ALERT ACTIONS

    static func standartAlertMessage(message: String, title: String, completionBlock: void_block?) {
        guard let topVC = Utils.topViewController(), !topVC.isKind(of: UIAlertController.self) else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "OK", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
            completionBlock?()
        }
        alertController.addAction(actionCancel)
        topVC.present(alertController, animated: true, completion: nil)
        
        return
    }
}
