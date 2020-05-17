//
//  FinanceOverviewCell.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 20.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class FinanceOverviewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryAmountLabel: UILabel!
    
    func updateOverviewCell(with data: [CategoryTotal], at indexPath: IndexPath) {
        categoryNameLabel.text = data[indexPath.row].name
        categoryAmountLabel.text = "\(Butler.createNumberFormatter(input: data[indexPath.row].balance))"
    }
}
