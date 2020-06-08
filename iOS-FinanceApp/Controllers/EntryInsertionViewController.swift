//
//  EntryInsertionViewController.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import PMSuperButton

class EntryInsertionViewController: UIViewController {
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        createDatePicker()
        createDatePickerToolbar()
        createCategoryPicker()
        dateInputTextField.inputView = datePicker
        dateInputTextField.inputAccessoryView = toolBar
        
        if let newData = incomingData {
            nameInputTextField.text = newData.name
            amntInputTextField.text = "\(abs(newData.amount))"
            dateInputTextField.text = "\(Butler.createDateFormatter(dateStyle: .medium, timeStyle: .none).string(from: newData.date!))"
            categoryInputTextField.text = newData.category
            
            switch newData.entryType {
            case "Income":
                typeControl.selectedSegmentIndex = 0
            case "Expense":
                typeControl.selectedSegmentIndex = 1
            default: break
            }
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
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    // MARK: - Programmatic Properties
    var datePicker = UIDatePicker()
    var categoryPicker  = UIPickerView()
    var toolBar = UIToolbar()
    var incomingData: Entry? = nil
    let notificationCenter = NotificationCenter.default
    var pickerData: [String] {
        get {
            let uniques = Array(Set(realm.objects(Category.self).value(forKeyPath: "name") as! Array<String>))
            return uniques.sorted(by: <)
        }
    }
    
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
                    
                    if typeControl.selectedSegmentIndex == 1 {
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
                    switch typeControl.selectedSegmentIndex {
                    case 0:
                        entryToWrite.entryType = "Income"
                    case 1:
                        entryToWrite.entryType = "Expense"
                    default: break
                    }
                    
                    notificationCenter.post(name: .entryAmendSuccess, object: nil)
                    
                    print("Entry data updated.")
                }
                
                self.dismiss(animated: true, completion: flushTextFields)
                
                print("Now finished amending process.")
            } else {
                print("New entry created! Now saving...")
                
                var type: String {
                    // make separate func
                    var result: String = ""
                    switch typeControl.selectedSegmentIndex {
                    case 0:
                        result = "Income"
                    case 1:
                        result = "Expense"
                    default:
                        break
                    }
                    return result
                }
                
                let entry = Entry(
                    id: DataManager.generateId(),
                    name: nameInputTextField.text!,
                    amount: Int(amntInputTextField.text!)!,
                    date: (Butler.createDateFormatter(
                        dateStyle: .medium,
                        timeStyle: .none)
                        .date(from: dateInputTextField.text!))!,
                    category: categoryInputTextField.text!,
                    entryType: type,
                    ToC: "\(NSDate().timeIntervalSince1970)")
                
                switch typeControl.selectedSegmentIndex {
                case 1:
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
    
    // MARK: - Add Category Logic
    @IBAction func addCategory(_ sender: Any) {
        let alert = Butler.createInputAlertController(with: Butler.alertData[10][0], message: Butler.alertData[10][1], and: .alert)
        self.present(alert, animated: true, completion: nil)
        alert.actions[1].isEnabled = false
    }
    
    // MARK: - Date Picker & Toolbar Stuff
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(for:)),
            for: .valueChanged)
        datePicker.backgroundColor = .white
    }
    
    func createDatePickerToolbar() {
        toolBar = UIToolbar()
        
        let todayButton = UIBarButtonItem(
            title: "Today",
            style: .plain,
            target: self,
            action: #selector(todayButtonPressed(sender :)))
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonPressed(sender:)))
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil)
        
        toolBar.setItems([todayButton, flexibleSpace, doneButton], animated: true)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
    }
}

// MARK: - Category Picker & Toolbar Stuff
extension EntryInsertionViewController {
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(categoryPickerDoneButtonHit))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(categoryPickerDoneButtonHit))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        categoryInputTextField.inputView = categoryPicker
        categoryInputTextField.inputAccessoryView = toolBar
    }
    
    @objc func categoryPickerDoneButtonHit() {
        categoryInputTextField.resignFirstResponder()
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 3 {
            categoryPicker.isHidden = false
            textField.text!.isEmpty ? textField.text = "\(pickerData[categoryPicker.selectedRow(inComponent: 0)])" : nil
        }
        
        if textField.tag == 2 {
            textField.text!.isEmpty ? datePickerValueChanged(for: datePicker) : nil
        }
        return true
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
        
        //        guard !typeTextField.text!.isEmpty else {
        //            self.present(Butler.createAlertController(
        //                with: Butler.alertData[8][0],
        //                message: Butler.alertData[8][1],
        //                and: .alert)
        //                , animated: true, completion: nil)
        //            throw ValidationErrors.typeIsEmpty }
        //
        //        guard validator.inputIsValidated(
        //            input: typeTextField.text!,
        //            pattern: validator.regExes["alphaNumericRegEx"]!) else {
        //                self.present(Butler.createAlertController(
        //                    with: Butler.alertData[9][0],
        //                    message: Butler.alertData[9][1],
        //                    and: .alert)
        //                    , animated: true, completion: nil)
        //                throw ValidationErrors.typeMismatch }
    }
}

// MARK: - Picker View Data Source
extension EntryInsertionViewController: UIPickerViewDataSource {
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
extension EntryInsertionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryInputTextField.text = pickerData[row]
    }
}
