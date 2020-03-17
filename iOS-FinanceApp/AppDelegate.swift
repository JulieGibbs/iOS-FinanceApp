//
//  AppDelegate.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let transactionsTest = Transaction()
        
        transactionsTest.addIncome(name: "Salary", amount: 1000, date: Date(timeIntervalSinceNow: 388))
        transactionsTest.addIncome(name: "Returned Loan", amount: 1500, date: Date(timeIntervalSinceNow: 1666))
        transactionsTest.addIncome(name: "Found Money", amount: 50, date: Date(timeIntervalSinceNow: 565))
        
        transactionsTest.addExpense(name: "Cat", amount: 10, date: Date(timeIntervalSinceNow: 54))
        transactionsTest.addExpense(name: "Dog", amount: 15, date: Date(timeIntervalSinceNow: 524))
        transactionsTest.addExpense(name: "Fish", amount: 5, date: Date(timeIntervalSinceNow: 123))
        
        let balance = transactionsTest.balance
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

