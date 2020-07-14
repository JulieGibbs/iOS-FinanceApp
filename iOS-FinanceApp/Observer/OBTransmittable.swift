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
    
    var incomeExtremums: [Int?] { get set }
    var expensesExtremums: [Int?] { get set }
    
    var dailyIncomeData: [ClosedRange<Int> : Int] { get set }
    var dailyExpenseData: [ClosedRange<Int> : Int] { get set }
    
    var weeklyIncomeData: [String : Int] { get set }
    var weeklyExpenseData: [String : Int] { get set }
    
    var monthlyIncomeData: [Int : Int] { get set }
    var monthlyExpenseData: [Int : Int] { get set }
    
    var yearlyIncomeData: [Int: Int] { get set }
    var yearlyExpenseData: [Int: Int] { get set }
    
    var description: String { get set }
}
