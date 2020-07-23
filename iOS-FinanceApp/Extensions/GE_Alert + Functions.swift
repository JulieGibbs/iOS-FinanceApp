//
//  Alert Controller + Validation &.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 03.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

extension UIAlertController {
    func categoryDidValidated(_ category: String) -> Bool {
        return category.count > 0
    }
    
    @objc func submitButtonDidEnabled() {
        if let categoryName = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = categoryDidValidated(categoryName)
        }
    }
}
