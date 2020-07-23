//
//  GE_UILabel.swift
//  iOS-FinanceApp
//
//  Created by user173649 on 7/15/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func resizeToText() {
        self.numberOfLines = 1
        self.sizeToFit()
    }
}
