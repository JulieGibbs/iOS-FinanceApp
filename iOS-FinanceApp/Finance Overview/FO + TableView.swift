//
//  FO + Table View.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 29.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

extension FOViewController: UITableViewDelegate {
}

extension FOViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pivotTableView.dequeueReusableCell(withIdentifier: "FinanceOverviewCell", for: indexPath) as! FOTableViewCell
        
        cell.updateOverviewCell(with: objectArray, at: indexPath)
        
        return cell
    }
}
