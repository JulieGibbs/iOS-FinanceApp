//
//  EntryInsertionViewController.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

protocol EntryInsertionDelegate {
    func dataDidSendOnInsertion(_ data: Int)
}

class EntryInsertionViewController: UIViewController {
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        createDatePicker()
        createToolbar()
        dateInputTextField.inputView = datePicker
        dateInputTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - Outlets
    @IBOutlet weak var imageForCategory: UIImageView!
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var amntInputTextField: UITextField!
    @IBOutlet weak var dateInputTextField: UITextField!
    @IBOutlet weak var categoryInputTextField: UITextField!
    @IBOutlet weak var isExpenseTextField: UITextField!
    
    // MARK: - Programmatic Properties
    var datePicker = UIDatePicker()
    let categoryPicker = UIPickerView() // needed for categories picking
    var toolBar = UIToolbar()
    var delegate: EntryInsertionDelegate?
    
    // MARK: - Add Entry Logic
    @IBAction func addEntryButton(_ sender: UIButton) {
        let validator = TextValidation()
        
        if validator.inputIsValidated(input: nameInputTextField.text!, pattern: validator.regExes["alphaNumericRegEx"]!) == true &&
            validator.inputIsValidated(input: amntInputTextField.text!, pattern: validator.regExes["numericRegEx"]!) == true &&
            isExpenseTextField.text == "Expense" ||
            isExpenseTextField.text == "Income"{
            
            let entry = Entry(name: nameInputTextField.text!,
                              amount: Int(amntInputTextField.text!)!,
                              date: Butler.createDateFormatter(dateStyle:
                                .short, timeStyle:
                                .none)
                                .date(from: dateInputTextField.text!)!,
                              category: categoryInputTextField.text!,
                              entryType: isExpenseTextField.text!)
            
            if isExpenseTextField.text! == "Expense" {
                entry.amount *= -1
                delegateDidWriteAndDismiss(input: entry)
            } else {
                delegateDidWriteAndDismiss(input: entry)
            }
        } else {
            let alert = UIAlertController(
                title: "invalid input",
                message: "some of the patterns did not match the input",
                preferredStyle: .alert)
            
            self.present(alert, animated: true, completion:  {
                sleep(1)
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - Date Picker and Toolbar Stuff
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(for:)), for: .valueChanged)
    }
    
    func createToolbar() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let todayButton = UIBarButtonItem(
            title: "Today",
            style: .plain,
            target: self,
            action: #selector(todayButtonPressed(sender :)))
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonPressed(sender:)))
        
        let label = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width / 5,
                height: 40))
        
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil)
        
        label.text = "Pick a date"
        
        toolBar.setItems([todayButton, flexibleSpace, labelButton, flexibleSpace, doneButton], animated: true)
    }
}

// MARK: - Text Field Return Key Switch
extension EntryInsertionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            amntInputTextField.becomeFirstResponder()
        }
        return false
    }
}

// MARK: - Date Picker Logic
extension EntryInsertionViewController {
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
    
    private func delegateDidWriteAndDismiss(input: Entry) {
        delegate?.dataDidSendOnInsertion(input.amount)
        Butler.writeToRealm(new: input)
        self.dismiss(animated: true, completion: nil)
    }
}
