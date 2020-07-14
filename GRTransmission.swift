//
//  GRTransmission.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

final class GRTransmission: Transmittable {
    var matchedEntries: [Entry]

    var incomeEntries: [Entry]
    var expensesEntries: [Entry]
    
    var income: [Int]
    var expenses: [Int]
    
    var totalForIncome: ([Int]) -> Int
    var totalForExpenses: ([Int]) -> Int
    
    var incomeExtremums: [Int]
    var expensesExtremums: [Int]
    
    var dailyIncomeData: [ClosedRange<Int> : Int]
    var dailyExpenseData: [ClosedRange<Int> : Int]
    
    var weeklyIncomeData: [String : Int]
    var weeklyExpenseData: [String : Int]
    
    var monthlyIncomeData: [Int : Int]
    var monthlyExpenseData: [Int : Int]
    
    var yearlyIncomeData: [Int : Int]
    var yearlyExpenseData: [Int : Int]
    
    /// Initializes GRTransmission for daily entries render
    /// - Parameters:
    ///   - matchedEntries: all entries that matched cut-off - needed for prudency purposes
    ///   - incomeEntries: matched splitted to income - needed to VC for operations
    ///   - income: all amounts of income type entries - needed for prudency purposes
    ///   - expenses: all amounts of expense type entries - needed for prudency purposes
    ///   - totalIncome: sum for income entry type amounts
    ///   - totalExpenses: sum for expense entry type amounts
    ///   - incomeExtremums: min / med / max for income
    ///   - expensesExtremums: min / med / max for expenses
    ///   - dailyIncome: income amounts split by hours (see GRDataSource / GRStackView)
    ///   - dailyExpense: income amounts split by hours (see GRDataSource / GRStackView)
    init(matchedEntries: [Entry], incomeEntries: [Entry], income: [Int], expenses: [Int], totalIncome: @escaping ([Int]) -> Int, totalExpenses: @escaping ([Int]) -> Int, incomeExtremums: [Int], expensesExtremums: [Int], dailyIncome: [ClosedRange<Int> : Int], dailyExpense: [ClosedRange<Int> : Int]) {
        
        self.matchedEntries = matchedEntries
        self.incomeEntries = incomeEntries
        
        self.income = income
        self.expenses = expenses
        
        self.totalForIncome = totalIncome
        self.totalForExpenses = totalExpenses
        
        self.incomeExtremums = incomeExtremums
        self.expensesExtremums = expensesExtremums
        
        self.dailyIncomeData = dailyIncome
        self.dailyExpenseData = dailyExpense
    }
    
    init(matchedEntries: [Entry], incomeEntries: [Entry], income: [Int], expenses: [Int], totalIncome: @escaping ([Int]) -> Int, totalExpenses: @escaping ([Int]) -> Int, incomeExtremums: [Int], expensesExtremums: [Int], weeklyIncome: [String : Int], weeklyExpense: [String : Int]) {
        
        self.matchedEntries = matchedEntries
        self.incomeEntries = incomeEntries
        
        self.income = income
        self.expenses = expenses
        
        self.totalForIncome = totalIncome
        self.totalForExpenses = totalExpenses
        
        self.incomeExtremums = incomeExtremums
        self.expensesExtremums = expensesExtremums
        
        self.weeklyIncomeData = weeklyIncome
        self.weeklyExpenseData = weeklyExpense
    }
    
    init(matchedEntries: [Entry], incomeEntries: [Entry], income: [Int], expenses: [Int], totalIncome: @escaping ([Int]) -> Int, totalExpenses: @escaping ([Int]) -> Int, incomeExtremums: [Int], expensesExtremums: [Int], monthlyIncome: [Int : Int], monthlyExpense: [Int : Int]) {
        
        self.matchedEntries = matchedEntries
        self.incomeEntries = incomeEntries
        
        self.income = income
        self.expenses = expenses
        
        self.totalForIncome = totalIncome
        self.totalForExpenses = totalExpenses
        
        self.incomeExtremums = incomeExtremums
        self.expensesExtremums = expensesExtremums
        
        self.monthlyIncomeData = monthlyIncome
        self.monthlyExpenseData = monthlyExpense
    }
    
    init(matchedEntries: [Entry], incomeEntries: [Entry], income: [Int], expenses: [Int], totalIncome: @escaping ([Int]) -> Int, totalExpenses: @escaping ([Int]) -> Int, incomeExtremums: [Int], expensesExtremums: [Int], yearlyIncome: [Int : Int], yearlyExpense: [Int : Int]) {
        
        self.matchedEntries = matchedEntries
        self.incomeEntries = incomeEntries
        
        self.income = income
        self.expenses = expenses
        
        self.totalForIncome = totalIncome
        self.totalForExpenses = totalExpenses
        
        self.incomeExtremums = incomeExtremums
        self.expensesExtremums = expensesExtremums
        
        self.yearlyIncomeData = yearlyIncome
        self.yearlyExpenseData = yearlyExpense
    }
}
