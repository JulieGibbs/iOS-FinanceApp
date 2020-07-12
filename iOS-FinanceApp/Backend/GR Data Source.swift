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
    var matchedEntries = [Entry]()
    var income = [Int]()
    var expenses = [Int]()
    
    var dailyData: [ClosedRange<Int> : Int] = [0...4 : 0,
                                               5...8 : 0,
                                               9...12: 0,
                                               13...16 : 0,
                                               17...20 : 0,
                                               21...24 : 0]
    
    var weeklyData: [String : Int] = ["Sunday" : 0,
                                      "Monday" : 0,
                                      "Tuesday" : 0,
                                      "Wednesday" : 0,
                                      "Thursday" : 0,
                                      "Friday" : 0,
                                      "Saturday" : 0]
    
    var monthlyData: [Int : Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    var yearlyData: [Int: Int] = [1 : 0, 2 : 0, 3 : 0, 4 : 0]
    
    func getTimeframeData(timeFrame: TimeFrame, input data: Results<Entry> = entries, cutOff: Date) {
        matchedEntries = data.filter({$0.date! >= cutOff})
        
        matchedEntries.forEach {
            $0.amount > 0 ? income.append($0.amount) : expenses.append($0.amount * -1)
        }
        
        let labelIncomeData = [income.max(), income.median(), income.min()]
        let labelExpenseData = [expenses.max(), expenses.median(), expenses.min()]
        
        var graphPointsData = [Int]()
        
        switch timeFrame {
        case .day:
            getDailyAmounts(input: matchedEntries)
        case .week:
            getWeeklyData(input: matchedEntries)
        case .month:
            getMonthlyData(input: matchedEntries)
        case .year:
            getYearlyAmounts(input: matchedEntries)
        default:
            break
        }
        
        Publisher.send(GRTransmission(
            income: income,
            expenses: expenses,
            labelsIncomeData: labelIncomeData,
            labelsExpenseData: labelExpenseData,
            incomeTotal: income.reduce(0, +),
            expensesTotal: expenses.reduce(0, +),
            graphPointsData: graphPointsData))
    }
    
    func getDailyAmounts(input: [Entry]){
        for (hours, _) in dailyData {
            dailyData[hours] = input.filter({ hours.contains($0.hour) }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
    }
    
    func getWeeklyData(input: [Entry]) {
        for (day, _) in weeklyData {
            weeklyData[day] = input.filter({ $0.weekDay == day }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
    }
    
    func getMonthlyData(input: [Entry]) {
        for (week, _) in monthlyData {
            monthlyData[week] = input.filter({ $0.weekOfMonth == week }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
    }
    
    func getYearlyAmounts(input: [Entry]){
        for (quarter, _) in yearlyData {
            yearlyData[quarter] = input.filter({ $0.quarter == quarter }).map({ (entry) -> Int in
                if entry.amount < 0 {
                    let amendedExpense: Int = entry.amount * -1
                    return amendedExpense
                } else { return entry.amount }}).reduce(0, +)}
    }
}

struct Expenses {
    static var amountSet = [Int]()
    
    static var max: Int {
        get { return amountSet.max() ?? 0 }
    }
    static var med: Int {
        get { return amountSet.median() ?? 0 }
    }
    static var min: Int {
        get { return amountSet.min() ?? 0 }
    }
}

struct Income {
    static var amountSet = [Int]()
    
    static var max: Int {
        get {
            if amountSet.count == 1 {
                return amountSet.first ?? 0
                
            } else {
                return amountSet.max() ?? 0
            }
        }
    }
    
    static var med: Int { if amountSet.count == 1 { return amountSet.first ?? 0 } else {
        return amountSet.median() ?? 0
        }
    }
    
    static var min: Int { if amountSet.count == 1 { return amountSet.first ?? 0 } else {
        return amountSet.min() ?? 0 }
    }
}
