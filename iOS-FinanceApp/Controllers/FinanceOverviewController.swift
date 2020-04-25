//
//  FinanceOverviewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

@IBDesignable
class FinanceOverviewController: UIViewController, EntryInsertionDelegate {
    // MARK: - Properties and Outlets
    @IBOutlet weak var financeOverviewTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var realm = try! Realm()
    let tableEntries = try! Realm().objects(Entry.self).sorted(byKeyPath: "date", ascending: true)
    let categoriesSum = try! Realm().objects(Entry.self).map({ $0.category })
    let entriesManager = EntriesManager()
    var notificationToken: NotificationToken?
        
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBalance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        financeOverviewTableView.delegate = self
        financeOverviewTableView.dataSource = self
        
        self.notificationToken = tableEntries.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.financeOverviewTableView.reloadData()
            case .update (_, let deletions, let insertions, let modifications):
                self.financeOverviewTableView.beginUpdates()
                self.financeOverviewTableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.financeOverviewTableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.financeOverviewTableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.financeOverviewTableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Transaction Segue" {
            if let vc = segue.destination as? EntryInsertionViewController {
                vc.delegate = self
            }
        }
    }
    
    func dataDidSendOnInsertion(_ data: Int) {
        currentBalanceLabel.text = "\((currentBalanceLabel.text! as NSString).integerValue + data)"
    }
    
    // MARK: - Actions
    @IBAction func addIncome(_ sender: UIButton) {
        performSegue(withIdentifier: "Add Transaction Segue", sender: UIButton())
    }
    
    @IBAction func tranferToReport(_ sender: Any) {
        performSegue(withIdentifier: "Expenses Details Segue", sender: UIButton())
    }
    
    @IBAction func transferToGraph(_ sender: Any) {
        performSegue(withIdentifier: "Graph View Segue", sender: UIButton())
    }
    
    // MARK: - Methods to Add Dummy Income and Expense
    
    
    // not used in code but suitable for tests!
    private func addDummyIncome() {
        let entry = Entry()
        let entryTag = "A"
        entry.amount = Int.random(in: 1000...5000)
        entry.name = entryTag
        writeToRealm(write: entry)
    }
    
    private func addDummyExpense() {
        let entry = Entry()
        let entryTag = "B"
        entry.amount = Int.random(in: 1000...5000) * -1
        entry.name = entryTag
        writeToRealm(write: entry)
    }
    
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

// MARK: - Table View Delegate
extension FinanceOverviewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm.beginWrite()
            realm.delete(tableEntries[indexPath.row])
            try! realm.commitWrite()
        }
    }
}

// MARK: - Table View Data Source
extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = financeOverviewTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        
        cell.entryNameLabel.text = categoriesSum[indexPath.row]
        
        return cell
    }
}
