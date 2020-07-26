//
//  GE_Float.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 26.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
