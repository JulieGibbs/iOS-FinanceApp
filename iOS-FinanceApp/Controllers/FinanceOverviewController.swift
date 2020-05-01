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
    @IBOutlet weak var financeOverviewTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var data = EntriesManager.mapCategories(from: allEntries)
    
    struct Objects {
        var categoryName: String?
        var balance: String?
    }
    
    var objectArray = [Objects]()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBalance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in data {
            print("\(key) -> \(value)")
            
            objectArray.append(Objects(categoryName: key, balance: String(value)))
        }
        
        financeOverviewTableView.delegate = self
        financeOverviewTableView.dataSource = self
        financeOverviewTableView.allowsSelection = false
    }
    
    // MARK: - Actions and Methods
    @IBAction func segueButtons(_ sender: PMSuperButton?) {
        switch sender?.tag {
        case 0:
            performSegue(withIdentifier: "Add Transaction Segue", sender: PMSuperButton()) // DRY 3
        case 1:
            performSegue(withIdentifier: "Expenses Details Segue", sender: PMSuperButton()) // DRY 3
        case 2:
            performSegue(withIdentifier: "Graph View Segue", sender: PMSuperButton()) // DRY 3
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Transaction Segue" {
            if let vc = segue.destination as? EntryInsertionViewController {
                vc.delegate = self
            }
        }
    }
    // MARK: - Helpers - ADD TO HELPER CLASS
    private func writeToRealm(write item: Entry) {
        realm.beginWrite()
        realm.add(item)
        try! realm.commitWrite()
    }
    
    func updateBalance() {
        let balance: Int = tableEntries.sum(ofProperty: "amount")
        currentBalanceLabel.text = "\(balance)"
    }
}

// MARK: - Table View Delegate - move to EntryInsertion
extension FinanceOverviewController: UITableViewDelegate {    
}

// MARK: - Table View Data Source - rewrite
extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = financeOverviewTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        
        cell.entryNameLabel.text = objectArray[indexPath.row].categoryName
        cell.entryAmountLabel.text = objectArray[indexPath.row].balance
        
        return cell
    }
}

// MARK: - Entry Insertion Delegate
extension FinanceOverviewController: EntryInsertionDelegate {
    func dataDidSendOnInsertion(_ data: Int) {
        currentBalanceLabel.text = "\((currentBalanceLabel.text! as NSString).integerValue + data)"
    }
}
