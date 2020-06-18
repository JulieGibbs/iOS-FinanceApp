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
final class Butler {
    // MARK: - Formatters
    static func createDateFormatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter
    }
    
    static func createNumberFormatter(input number: Int) -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
        
        return numberFormatter.string(from: NSNumber(integerLiteral: number))!
    }
    
    // MARK: - Alerts
    static var alertData: [[String]] = [["Name is missing",
                                         "Sorry, cannot proceed without a name. Please provide one. \n\nTips: use alphanumerics and (or) specials; length: 2 to 70 symbols."],
                                        
                                        ["Invalid entry name",
                                         "Sorry, the name is invalid. Please retry. \n\nTips: use alphanumerics and (or) specials; length: 2 to 70 symbols."],
                                        
                                        ["Amount is missing",
                                         "Sorry, cannot proceed without knowing the cost of the entry. Please provide one. \n\nTips: use numerics, arbitrary length."],
                                        
                                        ["Invalid amount",
                                         "Sorry, the amount is invalid. Please retry. \n\nTips: use numerics, arbitrary length."],
                                        
                                        ["Date is missing",
                                         "Sorry, cannot proceed without knowing when your entry was made. \n\nPlease provide the date."],
                                        
                                        ["Invalid date",
                                         "Sorry, the date is invalid. Please retry. \n\nTips: use only date picker."],
                                        
                                        ["Category is missing",
                                         "Sorry, cannot proceed without knowing the entry category. Please provide one. \n\nTips: use alphanumerics; arbitrary length."],
                                        
                                        ["Invalid Category",
                                         "Sorry, the category is invalid. Please select some from picker or add new. \n\nTips: use alphanumerics, arbitrary length. Only picker data is accepted."],
                                        
                                        ["Type is missing",
                                         "Sorry, cannot proceed without knowing whether the entry is an income or an expense. Please specify. \nTip: just type 'Income' or 'Expense', you do not need to put a negative sign."],
                                        
                                        ["Invalid Type",
                                         "Sorry, the type is missing. Please retry. \n\nTip: just type 'Income' or 'Expense', you do not need to put a negative sign."],
                                        
                                        ["Enter category name",
                                         "Please input some meaningful and descriptive name for your fresh category"],
                                        
                                        ["Category name cannot be empty!",
                                         "Please consider adding some meaningful and descriptive name"]]
    
    static func createAlertController(with title: String, message: String, and style: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: { _ in
                alertController.dismiss(
                    animated: true,
                    completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        return alertController
    }
    
    static func createInputAlertController(with title: String, message: String, and style: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style)
        
        let submitAction = UIAlertAction(
            title: "Submit",
            style: .default,
            handler: { _ in
                let category = Category(
                    id: DataManager.generateId(),
                    name: alertController.textFields![0].text!
                )
                DataManager.createEntry(category)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        alertController.addTextField {
            $0.placeholder = "Category name here..."
            $0.addTarget(
                alertController,
                action: #selector(
                    alertController.submitButtonDidEnabled),
                for: .editingChanged)
        }
        
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

extension UIAlertController {
    func categoryDidValidated(_ category: String) -> Bool {
        return category.count > 0
    }
    
    @objc func submitButtonDidEnabled() {
        if let categoryName = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = categoryDidValidated(categoryName)
        }
    }
}

extension NSExceptionName {
    static var shouldNeverHappenException: NSExceptionName {
        return.init("com.exc.this.should.never.happen")
    }
}
