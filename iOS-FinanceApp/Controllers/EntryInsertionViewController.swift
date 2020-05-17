//
//  EntryInsertionViewController.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class EntryInsertionViewController: UIViewController {
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        createDatePicker()
        createToolbar()
        dateInputTextField.inputView = datePicker
        dateInputTextField.inputAccessoryView = toolBar
        
        if let newData = incomingData {
            nameInputTextField.text = newData.name
            amntInputTextField.text = "\(abs(newData.amount))"
            dateInputTextField.text = "\(Butler.createDateFormatter(dateStyle: .medium, timeStyle: .none).string(from: newData.date!))"
            categoryInputTextField.text = newData.category
            typeTextField.text = newData.entryType
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flushTextFields()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var imageForCategory: UIImageView!
    @IBOutlet weak var nameInputTextField: UITextField!
    @IBOutlet weak var amntInputTextField: UITextField!
    @IBOutlet weak var dateInputTextField: UITextField!
    @IBOutlet weak var categoryInputTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    // MARK: - Programmatic Properties
    var datePicker = UIDatePicker()
    let categoryPicker = UIPickerView() // needed for categories picking - not started
    var toolBar = UIToolbar()
    var incomingData: Entry? = nil
    let notificationCenter = NotificationCenter.default
    
    // MARK: - Add Entry Logic
    @IBAction func addEntryButton(_ sender: UIButton) {
        do {
            print("Now starting validation of user input")
            
            try validateUserInput()
            
            print("Validation success! Now writing data to Realm...")
            
            if let entryToWrite = incomingData {
                print("Existing entry amended! Now updating...")
                
                try! realm.write {
                    entryToWrite.name = nameInputTextField.text
                    
                    if typeTextField.text == "Expense" {
                        print("System is about to write expense. Now adjusting entry amount...")
                        entryToWrite.amount = Int(amntInputTextField.text!)! * -1
                    } else {
                        entryToWrite.amount = Int(amntInputTextField.text!)!
                    }
                    
                    entryToWrite.date = Butler.createDateFormatter(
                        dateStyle:
                        .medium, timeStyle:
                        .none)
                        .date(from: dateInputTextField.text!)!
                    entryToWrite.category = categoryInputTextField.text!
                    entryToWrite.entryType = typeTextField.text!
                    
                    notificationCenter.post(name: .entryAmendSuccess, object: nil)
                    
                    print("Entry data updated.")
                }
                
                self.dismiss(animated: true, completion: flushTextFields)
                
                print("Now finished amending process.")
            } else {
                print("New entry created! Now saving...")
                
                let entry = Entry(
                    id: DataManager.generateId(),
                    name: nameInputTextField.text!,
                    amount: Int(amntInputTextField.text!)!,
                    date: (Butler.createDateFormatter(
                        dateStyle: .medium,
                        timeStyle: .none)
                        .date(from: dateInputTextField.text!))!,
                    category: categoryInputTextField.text!,
                    entryType: typeTextField.text!,
                    ToC: "\(NSDate().timeIntervalSince1970)")
                
                switch typeTextField.text {
                case "Expense":
                    print("Expense detected! Now adjusting amount...")
                    entry.amount *= -1
                    controllerDidWriteAndDismiss(input: entry)
                default:
                    controllerDidWriteAndDismiss(input: entry)
                }
                print("Now finished writing new entry.")
            }
        } catch {
            print("Error: \(error)")
            
        }
    }
    
    
    // MARK: - Date Picker and Toolbar Stuff
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(for:)),
            for: .valueChanged)
    }
    
    func createToolbar() {
        toolBar = UIToolbar(
            frame:
            CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 40))
        
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

// MARK: - Text Fields
extension EntryInsertionViewController: UITextFieldDelegate {
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
    
    private func controllerDidWriteAndDismiss(input: Entry) {
        DataManager.writeToRealm(input)
        self.dismiss(animated: true, completion: flushTextFields)
    }
}

// MARK: - Validation
extension EntryInsertionViewController {
    func validateUserInput() throws {
        let validator = TextValidation()
        
        guard !nameInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[0][0],
                message: Butler.alertData[0][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.nameIsEmpty }
        
        guard validator.inputIsValidated(
            input: nameInputTextField.text!,
            pattern: validator.regExes["alphaNumericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[1][0],
                    message: Butler.alertData[1][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.nameMismatch }
        
        guard !amntInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[2][0],
                message: Butler.alertData[2][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.amntIsEmpty }
        
        guard validator.inputIsValidated(
            input: amntInputTextField.text!,
            pattern: validator.regExes["numericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[3][0],
                    message: Butler.alertData[3][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.amntMismatch }
        
        guard !dateInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[4][0],
                message: Butler.alertData[4][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.dateIsEmtpy }
        
        guard validator.inputIsValidated(
            input: dateInputTextField.text!,
            pattern: validator.regExes["dateRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[5][0],
                    message: Butler.alertData[5][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.dateMismatch }
        
        guard !categoryInputTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[6][0],
                message: Butler.alertData[6][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.categoryIsEmpty }
        
        guard validator.inputIsValidated(
            input: categoryInputTextField.text!,
            pattern: validator.regExes["alphaNumericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[7][0],
                    message: Butler.alertData[7][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.categoryMismatch }
        
        guard !typeTextField.text!.isEmpty else {
            self.present(Butler.createAlertController(
                with: Butler.alertData[8][0],
                message: Butler.alertData[8][1],
                and: .alert)
                , animated: true, completion: nil)
            throw ValidationErrors.typeIsEmpty }
        
        guard validator.inputIsValidated(
            input: typeTextField.text!,
            pattern: validator.regExes["alphaNumericRegEx"]!) else {
                self.present(Butler.createAlertController(
                    with: Butler.alertData[9][0],
                    message: Butler.alertData[9][1],
                    and: .alert)
                    , animated: true, completion: nil)
                throw ValidationErrors.typeMismatch }
    }
}
