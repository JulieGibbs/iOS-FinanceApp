//
//  GRTransmission.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

final class GRTransmission: Transmittable {
    var incomeArray: [Int?]
    var expensesArray: [Int?]
    var incomeTotal: Int?
    var expensesTotal: Int?
    var graphPointsdata: [Any]
    var sideLabelsIncomeData: [Int?]
    var sideLabelsExpenseData: [Int?]
    
    init(income: [Int?], expenses: [Int?], labelsIncomeData: [Int?], labelsExpenseData: [Int?], incomeTotal: Int?, expensesTotal: Int?, graphPointsData: [Any]) {
        self.incomeArray = income
        self.expensesArray = expenses
        self.sideLabelsIncomeData = labelsIncomeData
        self.sideLabelsExpenseData = labelsExpenseData
        self.incomeTotal = incomeTotal
        self.expensesTotal = expensesTotal
        self.graphPointsdata = graphPointsData
    }
}
