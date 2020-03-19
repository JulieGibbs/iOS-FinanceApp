//
//  FinanceOverviewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class FinanceOverviewController: UIViewController {
    
    @IBOutlet weak var financeOverviewTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var tableEntries: Results<Entry>!
    let entriesManager = EntriesManager()
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.financeOverviewTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableEntries = realm.objects(Entry.self)
        financeOverviewTableView.delegate = self
        financeOverviewTableView.dataSource = self
    }
    
    @IBAction func addIncome(_ sender: UIButton) {
        let entry = Entry()
        var entryTag = "A"
        entry.amount = Int.random(in: 1000...5000)
        entry.name = entryTag
        writeToRealm(write: entry)
        entryTag += "!"
    }
    
    @IBAction func addExpense(_ sender: UIButton) {
        
    }
    
    private func writeToRealm(write item: Entry) {
        realm.beginWrite()
        realm.add(item)
        try! realm.commitWrite()
    }
}

extension FinanceOverviewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration()
    }
}

extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        let entryData = tableEntries[indexPath.row]
        
        cell.entryAmountLabel.text = String(entryData.amount)
        cell.entryNameLabel.text = entryData.name
        
        return cell
    }
}
