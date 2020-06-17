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

class FinanceOverviewController: UIViewController {
    // MARK: - Properties and Outlets
    @IBOutlet weak var pivotTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var data: [Dictionary<String, Int>.Element] {
        get { return DataManager.mapCategories(from: entries) }
    }
    
    var objectArray = [CategoryTotal]()
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshOverviewData()
        observe()
        
        pivotTableView.delegate = self // DRY
        pivotTableView.dataSource = self // DRY
        pivotTableView.allowsSelection = false // DRY
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
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
        self.view.layoutIfNeeded()
    }
    
    func gatherCategories() {
        self.objectArray.removeAll()
        
        for (key, value) in self.data {
            self.objectArray.append(CategoryTotal(name: key, balance: value))
        }
        self.pivotTableView.reloadData()
    }
    
    func observe() {
        notificationCenter.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryAddSuccess,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryRemoveSuccess,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(refreshOverviewData),
            name: .entryAmendSuccess,
            object: nil)
    }
}

// MARK: - Extensions
extension FinanceOverviewController: UITableViewDelegate {
}

extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pivotTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        
        cell.updateOverviewCell(with: objectArray, at: indexPath)
        
        return cell
    }
}
