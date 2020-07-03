//
//  ExpensesDetailsCell.swift
//  
//
//  Created by user168750 on 4/19/20.
//

import UIKit

class EDTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateDetailsCell(with data: Entry) {
        nameLabel.text = data.name
        amountLabel.text = "\(Heplers.createNumberFormatter(input: data.amount))"
        categoryLabel.text = data.category
        dateLabel.text = Heplers.createDateFormatter(
            dateStyle: .medium,
            timeStyle: .none)
            .string(from: data.date!)
    }
}
