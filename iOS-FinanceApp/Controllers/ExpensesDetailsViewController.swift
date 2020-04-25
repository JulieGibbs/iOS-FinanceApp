//
//  ExpensesDetailsViewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class ExpensesDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    let realm = try! Realm()
    let allEntries = try! Realm().objects(Entry.self).sorted(byKeyPath: "date", ascending: true)
    
    private var financeOverviewVC: FinanceOverviewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension ExpensesDetailsViewController: UITableViewDelegate {
    
}

extension ExpensesDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "ExpensesDetailsCell", for: indexPath) as! ExpensesDetailsCell
        
        cell.updateData(item: allEntries[indexPath.row])
        
        return cell
    }
    
    
}
