//
//  EI + Validation.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
extension EIViewController {
    func validateUserInput() throws {
        let validator = TextValidation()
        
        guard !nameInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[0][0],
                message: Butler.alertData[0][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.nameIsEmpty
        }
        
        guard TextValidation.inputIsValidated(
            input: nameInputTextField.text!,
            pattern: validator.regExes["alphaNumericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[1][0],
                    message: Butler.alertData[1][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.nameMismatch
        }
        
        guard !amntInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[2][0],
                message: Butler.alertData[2][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.amntIsEmpty
        }
        
        guard TextValidation.inputIsValidated(
            input: amntInputTextField.text!,
            pattern: validator.regExes["numericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[3][0],
                    message: Butler.alertData[3][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.amntMismatch
        }
        
        guard !categoryInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[6][0],
                message: Butler.alertData[6][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.categoryIsEmpty
        }
        
        guard TextValidation.inputIsValidated(
            input: categoryInputTextField.text!,
            pattern: validator.regExes["alphaNumericRegEx"]!),
            pickerData.contains(categoryInputTextField.text!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[7][0],
                    message: Butler.alertData[7][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.categoryMismatch
        }
    }
}
