//
//  Information.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

protocol Transmittable: class {
    var income: [Int?] { get set }
    var expenses: [Int?] { get set }
    var sideLabelsIncomeData: [Int?] { get set }
    var sideLabelsExpenseData: [Int?] { get set }
}
