//
//  AppDelegate.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appHasAlreadyLaunched: Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Check Firsl Launch Ever
        appHasAlreadyLaunched = UserDefaults.standard.bool(forKey: "appHasAlreadyLaunched")
        if appHasAlreadyLaunched { appHasAlreadyLaunched = true }
        else { UserDefaults.standard.set(true, forKey: "appHasAlreadyLaunched") }
        
        let today = NSDate()
        let sevenDaysAgo = today.add
        print(today, sevenDaysAgo)
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
