//
//  EDViewController + Table View.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

// MARK: - Table View Delegate
extension EDViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") {
                (action, view, completionHandler) in
                
                DataManager.deleteEntry(entries[indexPath.row])
                
                self.detailsTableView.deleteRows(
                    at: [indexPath],
                    with: .automatic)
                
                completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        entryDidSendToReview = entries[indexPath.row]
        performSegue(withIdentifier: "Amend Entry Segue", sender: indexPath)
    }
}

// MARK: - Table View Data Source
extension EDViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(
            withIdentifier: "ExpensesDetailsCell",
            for: indexPath) as! EDTableViewCell
        
        cell.updateDetailsCell(with: entries[indexPath.row])
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
}

extension EDViewController {
    func setupTableView() {
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.rowHeight = UITableView.automaticDimension
    }
}
