//
//  EI + Text Fields.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

extension EIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            amntInputTextField.becomeFirstResponder()
        }
        return false
    }
    
    func flushTextFields() {
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 2:
            textField.text!.isEmpty ? datePickerValueChanged(for: datePicker) : nil
        case 3:
            !pickerData.isEmpty ? textField.text = "\(pickerData[categoryPicker.selectedRow(inComponent: 0)])" : nil
        default: break
        }
        return true
    }
}
