//
//  FinanceOverviewCell.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 20.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class FinanceOverviewCell: UITableViewCell {
    
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var entryAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateData(name: String, amount: String) {
        entryNameLabel?.text = name
        entryAmountLabel?.text = amount
    }
}
