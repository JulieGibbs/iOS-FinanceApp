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
        detailsTableView.rowHeight = UITableView.automaticDimension
        
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: .entryAddSuccess, object: nil)
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: .entryAmendSuccess, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var detailsTableView: UITableView!
    var entryDidSendToReview: Entry?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Amend Entry Segue" {
            let destinationController = segue.destination as! EntryInsertionViewController
            destinationController.incomingData = entryDidSendToReview
        }
    }
    
    @objc func reloadData() {
        detailsTableView.reloadData()
    }
}

// MARK: - Table View Delegate
extension ExpensesDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") {
                (action, view, completionHandler) in
                
                DataManager.deleteFromRealm(entries[indexPath.row])
                
                self.detailsTableView.deleteRows(
                    at: [indexPath],
                    with: .automatic)
                
                completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        entryDidSendToReview = entries[indexPath.row]
        performSegue(withIdentifier: "Amend Entry Segue", sender: indexPath)
    }
}

// MARK: - Table View Data Source
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
