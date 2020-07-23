//
//  Information.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

protocol Transmittable: class {
    var matchedEntries: [Entry] { get set }
    
    var incomeEntries: [Entry] { get set }
    var expensesEntries: [Entry] { get set }
    
    var income: [Int] { get set }
    var expenses: [Int] { get set }
    
    var totalForIncome: Int { get set }
    var totalForExpenses: Int { get set }
    
    var incomeExtremums: [Int] { get set }
    var expensesExtremums: [Int] { get set }
    
    var dailyIncomeData: [Dictionary<ClosedRange<Int>, Int>.Element] { get set }
    var dailyExpenseData: [Dictionary<ClosedRange<Int>, Int>.Element] { get set }
    
    var weeklyIncomeData: [Dictionary<Int, Int>.Element] { get set }
    var weeklyExpenseData: [Dictionary<Int, Int>.Element] { get set }
    
    var monthlyIncomeData: [Dictionary<Int, Int>.Element] { get set }
    var monthlyExpenseData: [Dictionary<Int, Int>.Element] { get set }
    
    var yearlyIncomeData: [Int: Int] { get set }
    var yearlyExpenseData: [Int: Int] { get set }
    
    var description: String { get set }
}
