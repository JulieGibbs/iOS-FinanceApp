//
//  Array + Median.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 03.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    func median() -> Int? {
        guard count > 0 else { return nil }
        
        let sortedArray = self.sorted()
        
        if count % 2 != 0 {
            return sortedArray[count / 2]
        } else {
            return sortedArray[count / 2] + sortedArray[count / 2 - 1] / 2
        }
    }
}
