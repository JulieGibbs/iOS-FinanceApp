//
//  EI + DatePicker.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

extension EIViewController {
    @objc func datePickerValueChanged(for datePicker: UIDatePicker) {
        dateInputTextField.text = Butler.createDateFormatter(
            dateStyle: .medium,
            timeStyle: .none).string(from: datePicker.date)
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        dateInputTextField.text = Butler.createDateFormatter(
            dateStyle: .medium,
            timeStyle: .none).string(from: Date())
        
        dateInputTextField.resignFirstResponder()
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        dateInputTextField.resignFirstResponder()
    }
    
    func controllerDidWriteAndDismiss(input: Entry) {
        DataManager.createEntry(input)
        self.dismiss(animated: true, completion: flushTextFields)
    }
}
