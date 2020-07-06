//
//  EntryInsertionViewController.swift
//  iOS-FinanceApp
//
//  Created by user168750 on 4/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class EIViewController: UIViewController {
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
                    
                    entryToWrite.date = Heplers.createDateFormatter(
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
                    date: (Heplers.createDateFormatter(
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
        let alert = Heplers.createInputAlertController(with: Heplers.alertData[10][0], message: Heplers.alertData[10][1], and: .alert)
        self.present(alert, animated: true, completion: nil)
        alert.actions[1].isEnabled = false
    }
    
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
            dateInputTextField.text = "\(Heplers.createDateFormatter(dateStyle: .medium, timeStyle: .none).string(from: newData.date!))"
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
