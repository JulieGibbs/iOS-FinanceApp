//
//  FinanceOverviewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift
import PMSuperButton

// MARK: - Struct for Categories Table
struct Objects {
    var categoryName: String?
    var balance: Int?
}

class FinanceOverviewController: UIViewController {
    // MARK: - Properties and Outlets
    @IBOutlet weak var pivotTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var data = DataManager.mapCategories(from: entries)
    var objectArray = [Objects]()
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshOverviewData()
        observe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pivotTableView.delegate = self // DRY
        pivotTableView.dataSource = self // DRY
        pivotTableView.allowsSelection = false // DRY
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions and Methods
    @IBAction func segueButtons(_ sender: PMSuperButton?) {
        switch sender?.tag {
        case 0:
            performSegue(
                withIdentifier: "Add Transaction Segue",
                sender: PMSuperButton()) // DRY 3
        case 1:
            performSegue(
                withIdentifier: "Expenses Details Segue",
                sender: PMSuperButton()) // DRY 3
        case 2:
            performSegue(
                withIdentifier: "Graph View Segue",
                sender: PMSuperButton()) // DRY 3
        default:
            break
        }
    }
    
    // MARK: - Helpers - ADD TO HELPER CLASS
    @objc func refreshOverviewData() {
        updateBalance()
        gatherCategories()
    }
    
    func updateBalance() {
        let balance: Int = entries.sum(ofProperty: "amount")
        currentBalanceLabel.text = "\(Butler.createNumberFormatter(input: balance))"
        self.currentBalanceLabel.layoutIfNeeded()
    }
    
    func gatherCategories() {
        for (key, value) in self.data {
            self.objectArray.append(Objects(categoryName: key, balance: value))
        }
        
        self.pivotTableView.reloadData()
    }
    
    func observe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .balanceDidChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryDidAdded,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryDidAmended,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryDidRemoved,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .categoryNameDidChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .categoryDidAdded,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .categoryDidRemoved,
            object: nil)
    }
}

// MARK: - Table View Delegate
extension FinanceOverviewController: UITableViewDelegate {    
}

// MARK: - Table View Data Source - rewrite
extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pivotTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        
        cell.categoryNameLabel.text = objectArray[indexPath.row].categoryName
        cell.categoryAmountLabel.text = Butler.createNumberFormatter(input: objectArray[indexPath.row].balance!)
        
        return cell
    }
}
