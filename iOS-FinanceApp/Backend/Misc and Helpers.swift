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
    
    // MARK: - Alerts
    static var alertData: [[String]] = [
        [
            "Name is missing",
            "Sorry, cannot proceed without a name. Please provide one. \nTips: use alphanumerics and (or) specials; length: 2 to 70 symbols."
        ],
        
        [
            "Invalid entry name",
            "Sorry, the name is invalid. Please retry. \nTips: use alphanumerics and (or) specials; length: 2 to 70 symbols."
        ],
        
        [
            "Amount is missing",
            "Sorry, cannot proceed without knowing the cost of the entry. Please provide one. \nTips: use numerics, arbitrary length."
        ],
        
        [
            "Invalid amount",
            "Sorry, the amount is invalid. Please retry. \nTips: use numerics, arbitrary length."
        ],
        
        [
            "Date is missing",
            "Sorry, cannot proceed without knowing when your entry was made. \nPlease provide the date."
        ],
        
        [
            "Invalid date",
            "Sorry, the date is invalid. Please retry. \nTips: use only date picker."
        ],
        
        [
            "Category is missing",
            "Sorry, cannot proceed without knowing the entry category. Please provide one. \nTips: use alphanumerics; arbitrary length."
        ],
        
        [
            "Invalid Category",
            "Sorry, the category is invalid. Please retry. \nTips: use alphanumerics, arbitrary length."
        ],
        
        [
            "Type is missing",
            "Sorry, cannot proceed without knowing whether the entry is an income or an expense. Please specify. \nTip: just type 'Income' or 'Expense', you do not need to put a negative sign."
        ],
        
        [
            "Invalid Type",
            "Sorry, the type is missing. Please retry. \nTip: just type 'Income' or 'Expense', you do not need to put a negative sign."
        ]
    ]
    
    class func createAlertController(with title: String, message: String, and style: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        return alertController
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
