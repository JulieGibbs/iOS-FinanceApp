//
//  DataValidation.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/29/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

// MARK: - Text Validation
class TextValidation {
    let regExes: [String:String] = [
        "alphaNumericRegEx" : "[A-Za-z0-9\\D]{2,70}",
        "numericRegEx" : "\\d+",
        "dateRegEx" : "[A-Z]{1}[a-z]+\\d,\\d+",
        "pwdRegEx" : "([1-zA-Z0-1@.\\S\\s]{1,255})",
        "typeRegEx" : "(Income)|(Expense)"
    ]
    
    static public func inputIsValidated(input text: String, pattern regEx: String) -> Bool {
        if text.isEmpty { return false } else {
            return createPredicate(pattern: regEx).evaluate(with: whitespacesDidTrim(input: text))
        }
    }
    
    static private func createPredicate(pattern regEx: String) -> NSPredicate {
        return NSPredicate(format: "SELF MATCHES %@", regEx)
    }
    
    static private func whitespacesDidTrim(input: String) -> String {
        return input.doesContainWhitespacesAndNewLines ? input.filter { !$0.isNewline && !$0.isWhitespace } : input
    }
}

// MARK: - Errors
enum ValidationErrors: Error {
    /**
     NOTE - structured by generality / all possible variants listed:
     - empty fields errors
     - regEx mismatch errors
     */
    
    case nameIsEmpty
    case nameMismatch
    
    case amntIsEmpty
    case amntMismatch
    
    case dateIsEmtpy
    case dateMismatch
    
    case categoryIsEmpty
    case categoryMismatch
    
    case typeIsEmpty
    case typeMismatch
}
