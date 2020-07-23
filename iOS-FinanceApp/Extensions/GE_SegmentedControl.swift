//
//  GE_SegmentedControl.swift
//  iOS-FinanceApp
//
//  Created by user173649 on 7/14/20.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setup(input: [String]) {
        input.forEach {
            var index = 0
            insertSegment(withTitle: $0, at: index, animated: true)
            index += 1
        }
        selectedSegmentIndex = 0
    }
}
