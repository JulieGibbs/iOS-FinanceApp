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
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
    }
    
    // MARK: - Outlets
    @IBOutlet weak var detailsTableView: UITableView!
}

// MARK: - Extensions
extension ExpensesDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") {
                (action, view, completionHandler) in
                realm.beginWrite()
                realm.delete(entries[indexPath.row])
                try! realm.commitWrite()
                
                self.detailsTableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ExpensesDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(
            withIdentifier: "ExpensesDetailsCell",
            for: indexPath) as! ExpensesDetailsCell
        
        cell.updateData(item: entries[indexPath.row])
        return cell
    }
}
