//
//  AppDelegate.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        for _ in 0...50 {
            AppSettings.randomColors.append(UIColor(red: .random(in: 0...1),
                                        green: .random(in: 0...1),
                                        blue: .random(in: 0...1),
                                        alpha: 1.0))
        }
        
        return true
    }
}

