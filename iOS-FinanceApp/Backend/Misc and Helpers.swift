//
//  Misc and Helpers.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/19/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Class for Repeated Methods
class Butler {
    // MARK: - Singleton - consider usage
    static let shared = Butler()
    
    // MARK: - Formatters
    class func createDateFormatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter
    }
    
    class func createNumberFormatter(input number: Int) -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
        
        return numberFormatter.string(from: NSNumber(integerLiteral: number))!
    }
}

// MARK: - Keyboard Dismiss
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Notifications
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
    
    static let entryDidAmended = Notification.Name("entryDidAmended")
    static let entryDidRemoved = Notification.Name("entryDidRemoved")
    
    static let nameValidationDidFailed = Notification.Name("nameValidationDidFailed")
    static let amntValidationDidFailed = Notification.Name("amntValidationDidFailed")
    static let dateValidationDidFailed = Notification.Name("dateValidationDidFailed")
    static let categoryValidationDidFailed = Notification.Name("categoryValidationDidFailed")
    static let typeValidationDidFailed = Notification.Name("typeValidationDidFailed")
}
