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
    
    var incomeExtremums: [Int?]
    var expensesExtremums: [Int?]
    
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
    init(matchedEntries: [Entry], incomeEntries: [Entry], expensesEntries: [Entry], income: [Int], expenses: [Int], totalIncome: @escaping ([Int]) -> Int, totalExpenses: @escaping ([Int]) -> Int, incomeExtremums: [Int?], expensesExtremums: [Int?], dailyIncome: [ClosedRange<Int> : Int], dailyExpense: [ClosedRange<Int> : Int], weeklyIncome: [String : Int], weeklyExpense: [String : Int], monthlyIncome: [Int : Int], monthlyExpense: [Int : Int], yearlyIncome: [Int : Int], yearlyExpense: [Int : Int]) {
        
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
            Matched entries: \(matchedEntries);
            ------------------------------------------------\n
            Income Entries: \(incomeEntries);
            Expenses Entries: \(expensesEntries);
            ------------------------------------------------\n
            Income: \(income);
            Expenses: \(expenses);
            ------------------------------------------------\n
            Income Total: \(totalForIncome);
            Expenses Total: \(totalForExpenses);
            ------------------------------------------------\n
            Income Min / Med / Max: \(incomeExtremums);
            Expenses Min / Med / Max: \(expensesExtremums);
            ================================================\n
            Daily Income Data \(dailyIncomeData);
            Daily Expense Data \(dailyIncomeData);
            ------------------------------------------------\n
            Weekly Income Data \(weeklyIncomeData);
            Weekly Expense Data \(weeklyExpenseData);
            ------------------------------------------------\n
            Monthly Income Data \(monthlyIncomeData);
            Monthly Expense Data \(monthlyExpenseData);
            ------------------------------------------------\n
            Yearly Income Data \(yearlyIncomeData);
            Yearly Expense Data \(yearlyExpenseData);
            """
        }
        set {  }
    }
}
