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
    
    var realm = try! Realm()
    let tableEntries = try! Realm().objects(Entry.self)
    let entriesManager = EntriesManager()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.financeOverviewTableView.reloadData()
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
    
    @IBAction func addIncome(_ sender: UIButton) {
        let entry = Entry()
        let entryTag = "A"
        entry.amount = Int.random(in: 1000...5000)
        entry.name = entryTag
        writeToRealm(write: entry)
    }
    
    @IBAction func addExpense(_ sender: UIButton) {
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
}

extension FinanceOverviewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm.beginWrite()
            realm.delete(tableEntries[indexPath.row])
            try! realm.commitWrite()
        }
    }
}

extension FinanceOverviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = financeOverviewTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FinanceOverviewCell
        
        cell.updateData(item: tableEntries[indexPath.row])
        
        return cell
    }
}
