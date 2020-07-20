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
    
    var totalForIncome: Int
    var totalForExpenses: Int
    
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
    init(matchedEntries: [Entry], incomeEntries: [Entry], expensesEntries: [Entry], income: [Int], expenses: [Int], totalIncome: Int, totalExpenses: Int, incomeExtremums: [Int], expensesExtremums: [Int], dailyIncome: [ClosedRange<Int> : Int], dailyExpense: [ClosedRange<Int> : Int], weeklyIncome: [String : Int], weeklyExpense: [String : Int], monthlyIncome: [Int : Int], monthlyExpense: [Int : Int], yearlyIncome: [Int : Int], yearlyExpense: [Int : Int]) {
        
        self.matchedEntries = matchedEntries
        self.incomeEntries = incomeEntries
        self.expensesEntries = expensesEntries
        
        self.income = income
        self.expenses = expenses
        
        self.totalForIncome = totalIncome
        self.totalForExpenses = totalExpenses
        
        self.incomeExtremums = incomeExtremums
        self.expensesExtremums = expensesExtremums
        
        self.dailyIncomeData = dailyIncome
        self.dailyExpenseData = dailyExpense
        
        self.weeklyIncomeData = weeklyIncome
        self.weeklyExpenseData = weeklyExpense
        
        self.monthlyIncomeData = monthlyIncome
        self.monthlyExpenseData = monthlyExpense
        
        self.yearlyIncomeData = yearlyIncome
        self.yearlyExpenseData = yearlyExpense
        
    }
    
    var description: String {
        get {
            return """
            ***PRINTING MESSAGE DESCRIPTION***
            - All matched entries: \(matchedEntries);
            
            - Entries by type:
            \t- Income Entries: \(incomeEntries);
            \t- Expenses Entries: \(expensesEntries);
            
            - Values arrays by type:
            \t- Income: \(income);
            \t- Expenses: \(expenses);
            
            - Totals:
            \t- Income Total: \(totalForIncome);
            \t- Expenses Total: \(totalForExpenses);
            
            - Extremums:
            \t- Income Min / Med / Max: \(incomeExtremums);
            \t- Expenses Min / Med / Max: \(expensesExtremums);
            
            - Dictionaries:
            \t- Daily data:
            \t\t- Daily Income Data \(dailyIncomeData);
            \t\t- Daily Expense Data \(dailyIncomeData);
            
            \t- Weekly data:
            \t\t- Weekly Income Data \(weeklyIncomeData);
            \t\t- Weekly Expense Data \(weeklyExpenseData);
            
            \t- Monthly data:
            \t\t- Monthly Income Data \(monthlyIncomeData);
            \t\t- Monthly Expense Data \(monthlyExpenseData);
            
            \t- Yearly data:
            \t\t- Yearly Income Data \(yearlyIncomeData);
            \t\t- Yearly Expense Data \(yearlyExpenseData);
            """
        }
        set {  }
    }
}
