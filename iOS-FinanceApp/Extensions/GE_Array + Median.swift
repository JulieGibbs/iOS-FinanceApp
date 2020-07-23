//
//  Array + Median.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 03.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    func median() -> Float {
        guard !self.isEmpty else {
            return 0.00
        }
        
        let sorted = self.sorted()
        
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2])
        }
    }
}
