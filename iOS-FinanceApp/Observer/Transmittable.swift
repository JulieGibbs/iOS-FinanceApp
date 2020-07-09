//
//  Information.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

protocol Transmittable: class {
    var incomeArray: [Int?] { get set }
    var expensesArray: [Int?] { get set }
    var incomeTotal: Int? { get set }
    var expensesTotal: Int? { get set }
    var sideLabelsIncomeData: [Int?] { get set }
    var sideLabelsExpenseData: [Int?] { get set }
}
