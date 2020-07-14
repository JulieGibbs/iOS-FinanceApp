//
//  GREntryTypeToggle.swift
//  iOS-FinanceApp
//
//  Created by user173649 on 7/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

class GREntryTypeToggle: UISegmentedControl {
    let items = ["Expenses", "Income"]
    
    override func didMoveToSuperview() {
        setup(input: items)
        constrain()
    }
    
    @objc func entryToggleTapped(_ sender: GREntryTypeToggle) {
        switch selectedSegmentIndex {
        case 0: break
        case 1: break
        default: break
        }
    }
    
    func constrain() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            
            let safeArea = superview.safeAreaLayoutGuide
            
            let constraints = [leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20)]
            constraints.forEach({ $0.isActive = true })
        }
    }
}
