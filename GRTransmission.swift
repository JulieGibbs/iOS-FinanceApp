//
//  Side Labels Transmission.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 07.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

final class GRTransmission: Transmittable {
    var income: [Int?]
    var expenses: [Int?]
    var sideLabelsIncomeData: [Int?]
    var sideLabelsExpenseData: [Int?]
    
    init(income: [Int?], expenses: [Int?], labelsIncomeData: [Int?], labelsExpenseData: [Int?]) {
        self.income = income
        self.expenses = expenses
        self.sideLabelsIncomeData = labelsIncomeData
        self.sideLabelsExpenseData = labelsExpenseData
    }
}

