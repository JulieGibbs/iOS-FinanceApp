//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

let notificationCenter = NotificationCenter.default

extension Notification.Name {
    
    static var entryAddSuccess: Notification.Name {
        return .init("com.entry.add.success")
    }
    
    static var entryRemoveSuccess: Notification.Name {
        return.init("com.entry.remove.success")
    }
    
    static var entryAmendSuccess: Notification.Name {
        return .init("com.entry.amend.success")
    }
    
    static var categoryAddSuccess: Notification.Name {
        return.init("com.category.add.success")
    }
    static var categoryRemoveSuccess: Notification.Name {
        return.init("com.category.remove.success")
    }
    static var categoryAmendSuccess: Notification.Name {
        return.init("com.category.amend.success")
    }
}
