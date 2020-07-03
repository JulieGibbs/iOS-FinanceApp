//
//  ExpensesDetailsViewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class EDViewController: UIViewController {
    // MARK: - Outlets and Properties
    @IBOutlet weak var detailsTableView: UITableView!
    var entryDidSendToReview: Entry?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observe()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Actions
    @IBAction func addCategory(_ sender: Any) {
        let alert = Heplers.createInputAlertController(with: Heplers.alertData[10][0], message: Heplers.alertData[10][1], and: .alert)
        self.present(alert, animated: true, completion: nil)
        alert.actions[1].isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Amend Entry Segue" {
            let destinationController = segue.destination as! EIViewController
            destinationController.incomingData = entryDidSendToReview
        }
    }
}



