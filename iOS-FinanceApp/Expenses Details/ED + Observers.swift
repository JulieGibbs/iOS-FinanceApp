//
//  EDVC + Observers.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension EDViewController {
    func observe() {
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: .entryAddSuccess, object: nil)
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: .entryAmendSuccess, object: nil)
    }
    
    @objc func reloadData() {
        detailsTableView.reloadData()
    }
}
