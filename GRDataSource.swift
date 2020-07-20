//
//  Graph Data Source.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 02.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

class GraphDataSource {
    typealias EntryTotal = ([Int]) -> Int
    
    var matchedEntries = [Entry]()
    
    var incomeEntries = [Entry]()
    var expensesEntries = [Entry]()
    
    var income = [Int]()
    var expenses = [Int]()
    
    var totalForIncome: Int = 0
    var totalForExpenses: Int = 0
    
    var incomeExtremums = [Int]()
    var expensesExtremums = [Int]()
    
    var dailyIncomeData: [ClosedRange<Int> : Int] = [0...4 : 0, 5...8 : 0, 9...12: 0, 13...16 : 0, 17...20 : 0, 21...24 : 0]
    var dailyExpenseData: [ClosedRange<Int> : Int] = [0...4 : 0, 5...8 : 0, 9...12: 0, 13...16 : 0, 17...20 : 0, 21...24 : 0]
    
    var weeklyIncomeData: [String : Int] = ["Sunday" : 0, "Monday" : 0, "Tuesday" : 0, "Wednesday" : 0, "Thursday" : 0, "Friday" : 0, "Saturday" : 0]
    var weeklyExpenseData: [String : Int] = ["Sunday" : 0, "Monday" : 0, "Tuesday" : 0, "Wednesday" : 0, "Thursday" : 0, "Friday" : 0, "Saturday" : 0]
    
    var monthlyIncomeData: [Int : Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    var monthlyExpenseData: [Int : Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    
    var yearlyIncomeData: [Int: Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    var yearlyExpenseData: [Int: Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    
    var graphData: [Any] = []
    
    func getTimeframeData(timeFrame: TimeFrame, input data: Results<Entry> = entries, cutOff: Date) {
        matchedEntries = data.filter({$0.date! >= cutOff})
        
        print("****** DATA SOURCE MATCHED SOME ENTRIES ******")
        
        print("All entries that matched:")
        
        matchedEntries.forEach({ entry in
            print("name: \(entry.name ?? "")")
            print("amount: \(entry.amount)")
            print("date: \(entry.date ?? Date())")
            print("\n")
        })
        
        print("****** NOW SPLITTING ENTRIES BY TYPE ******")
        
        matchedEntries.forEach {
            $0.amount > 0 ? incomeEntries.append($0) : expensesEntries.append($0)
            $0.amount > 0 ? income.append($0.amount) : expenses.append($0.amount * -1)
        }
        
        print("""
            \(incomeEntries.count) income entries matched
            They are: \(incomeEntries)\n
            """)
        
        print("""
            \(expensesEntries.count) expense entries matched
            They are: \(expensesEntries)\n
            """)
        
        print("""
            Income and expenses values arrays populated:
            \t- Income: \(income)
            \t- Expenses: \(expenses)\n\n
            """)
        
        print("****** NOW CALCULATING MIN / MED / MAX ******")
        
        print("""
            - Income:
            \t- min: \(income.min() ?? 0);
            \t- med: \(income.median() ?? 0);
            \t- max: \(income.max() ?? 0);
            - Expenseы:
            \t- min: \(expenses.min() ?? 0);
            \t- med: \(expenses.median() ?? 0);
            \t- max: \(expenses.max() ?? 0);\n\n
            """)
        
        incomeExtremums = [income.min() ?? 0, Int(income.median()) ?? 0, income.max() ?? 0]
        expensesExtremums = [expenses.min() ?? 0, Int(expenses.median()) ?? 0, expenses.max() ?? 0]
        
        graphData.append([incomeEntries, expensesEntries])
        graphData.append([income, expenses])
        
        graphData.append([incomeExtremums, expensesExtremums])
        
        print("****** NOW CALCULATING TOTALS FOR INCOME / EXPENSES ******")
        
        totalForIncome = income.reduce(0, +)
        totalForExpenses = expenses.reduce(0, +)
        graphData.append([totalForIncome, totalForExpenses])
        
        print("""
            Income total: \(totalForIncome);
            Expense total: \(totalForExpenses);
            """)
        
        print("\nNB: dictionaries data will be printed upon message transmission.\n\n")
        
        switch timeFrame {
        case .day:
            dailyIncomeData = getDailyData(input: incomeEntries, inputDic: dailyIncomeData)
            dailyExpenseData = getDailyData(input: expensesEntries, inputDic: dailyExpenseData)
        case .week:
            weeklyIncomeData = getWeeklyData(input: incomeEntries, inputDic: weeklyIncomeData)
            weeklyExpenseData = getWeeklyData(input: expensesEntries, inputDic: weeklyExpenseData)
        case .month:
            monthlyIncomeData = getMonthlyData(input: incomeEntries, inputDic: monthlyIncomeData)
            monthlyExpenseData = getMonthlyData(input: expensesEntries, inputDic: monthlyExpenseData)
        case .year:
            yearlyIncomeData = getYearlyAmounts(input: incomeEntries, inputDic: yearlyIncomeData)
            yearlyExpenseData = getYearlyAmounts(input: expensesEntries, inputDic: yearlyExpenseData)
        default:
            break
        }
        
        let transmission = GRTransmission(
            matchedEntries: matchedEntries,
            incomeEntries: incomeEntries,
            expensesEntries: expensesEntries,
            income: income,
            expenses: expenses,
            totalIncome: totalForIncome,
            totalExpenses: totalForExpenses,
            incomeExtremums: incomeExtremums,
            expensesExtremums: expensesExtremums,
            dailyIncome: dailyIncomeData,
            dailyExpense: dailyExpenseData,
            weeklyIncome: weeklyIncomeData,
            weeklyExpense: weeklyExpenseData,
            monthlyIncome: monthlyIncomeData,
            monthlyExpense: monthlyExpenseData,
            yearlyIncome: yearlyIncomeData,
            yearlyExpense: yearlyExpenseData)
        
        Publisher.send(transmission)
    }
    
    func getDailyData(input: [Entry], inputDic: [ClosedRange<Int> : Int]) -> [ClosedRange<Int> : Int] {
        var res = inputDic
        
        for (hours, _) in res {
            res[hours] = input.filter({ hours.contains($0.hour) }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
        return res
    }
    
    func getWeeklyData(input: [Entry], inputDic: [String : Int]) -> [String : Int] {
        var res = inputDic
        
        for (day, _) in res {
            res[day] = input.filter({ $0.weekDay == day }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
        return res
    }
    
    func getMonthlyData(input: [Entry], inputDic: [Int : Int]) -> [Int : Int] {
        var res = inputDic
        
        for (week, _) in res {
            res[week] = input.filter({ $0.weekOfMonth == week }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
        return res
    }
    
    func getYearlyAmounts(input: [Entry], inputDic: [Int : Int]) -> [Int : Int] {
        var res = inputDic
        
        for (quarter, _) in res {
            res[quarter] = input.filter({ $0.quarter == quarter }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
        return res
    }
}
