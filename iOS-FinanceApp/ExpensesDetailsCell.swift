//
//  ExpensesDetailsCell.swift
//  
//
//  Created by user168750 on 4/19/20.
//

import UIKit
import RealmSwift

class ExpensesDetailsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(item: Entry) {
        nameLabel.text = item.name
        amountLabel.text = "\(item.amount)"
        categoryLabel.text = item.category
        dateLabel.text = "\(String(describing: item.date!))"
    }

}
