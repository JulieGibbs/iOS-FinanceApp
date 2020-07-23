//
//  EI + Picker.swift
//  iOS-FinanceApp
//
//  Created by user175587 on 6/29/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Picker View Data Source
extension EIViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

// MARK: - Picker View Delegate
extension EIViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputTextField.text = pickerData[row]
    }
}

// MARK: - Category Picker & Toolbar Stuff
extension EIViewController {
    func createCategoryPicker() {
        categoryPicker = UIPickerView(
            frame: CGRect(
                x: 0,
                y: 200,
                width: view.frame.width,
                height: 216)
        )
        
        categoryPicker.backgroundColor = .none
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(categoryPickerDoneButtonHit))
       
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(categoryPickerDoneButtonHit))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        categoryInputTextField.inputView = categoryPicker
        categoryInputTextField.inputAccessoryView = toolBar
    }
    
    @objc func categoryPickerDoneButtonHit() {
        categoryInputTextField.resignFirstResponder()
    }
}
