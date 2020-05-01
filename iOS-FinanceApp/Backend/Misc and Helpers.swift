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
    class func writeToRealm(new item: Entry) {
        realm.beginWrite()
        realm.add(item)
        try! realm.commitWrite()
    }
    
    class func createDateFormatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter
    }
}

// MARK: - Keyboard Dismiss
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
