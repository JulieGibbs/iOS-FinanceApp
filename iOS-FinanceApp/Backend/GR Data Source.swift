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
    
    
    func getTimeframeData(timeFrame: TimeFrame, input data: Results<Entry> = entries, cutOff: Date) {
//        data.forEach {
//            $0.date! >= cutOff ? matchedEntries.append($0) : nil
//        }
        
        matchedEntries = data.filter({$0.date! >= cutOff})
        
        matchedEntries.forEach {
            $0.amount > 0 ? income.append($0.amount) : expenses.append($0.amount * -1)
        }
        
        let labelIncomeData = [income.max(), income.median(), income.min()]
        let labelExpenseData = [expenses.max(), expenses.median(), expenses.min()]
        
        var graphPointsData = [Int]()
        
        switch timeFrame {
        case .day:
            graphPointsData = getDailyAmounts(input: matchedEntries)
        case .week:
            graphPointsData = getWeeklyAmounts(input: matchedEntries)
        case .month:
            graphPointsData = getMonthlyAmounts(input: matchedEntries)
        case .year:
            graphPointsData = getYearlyAmounts(input: matchedEntries)
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
    
    func getDailyAmounts(input: [Entry]) -> [Int] {
        let fourAM = input.filter({ $0.hour >= 0 && $0.hour <= 4 }).map({ $0.amount }).reduce(0, +)
        let eightAM = input.filter({ $0.hour >= 5 && $0.hour <= 8 }).map({ $0.amount }).reduce(0, +)
        let midday = input.filter({ $0.hour >= 9 && $0.hour <= 12 }).map({ $0.amount }).reduce(0, +)
        let fourPM = input.filter({ $0.hour >= 13 && $0.hour <= 16 }).map({ $0.amount }).reduce(0, +)
        let eightPM = input.filter({ $0.hour >= 17 && $0.hour <= 20 }).map({ $0.amount }).reduce(0, +)
        let midnight = input.filter({ $0.hour >= 21 && $0.hour <= 24 }).map({ $0.amount }).reduce(0, +)
        
        return [fourAM, eightAM, midday, fourPM, eightPM, midnight]
    }
    
    func getWeeklyAmounts(input: [Entry]) -> [Int] {
        let mon = input.filter({ $0.weekDay == "Monday" }).map({ $0.amount }).reduce(0, +)
        let tue = input.filter({ $0.weekDay == "Tuesday" }).map({ $0.amount }).reduce(0, +)
        let wed = input.filter({ $0.weekDay == "Wednesday" }).map({ $0.amount }).reduce(0, +)
        let thu = input.filter({ $0.weekDay == "Thursday" }).map({ $0.amount }).reduce(0, +)
        let fri = input.filter({ $0.weekDay == "Friday" }).map({ $0.amount }).reduce(0, +)
        let sat = input.filter({ $0.weekDay == "Saturday" }).map({ $0.amount }).reduce(0, +)
        let sun = input.filter({ $0.weekDay == "Sunday" }).map({ $0.amount }).reduce(0, +)
        
        return [mon, tue, wed, thu, fri, sat, sun]
    }
    
    func getMonthlyAmounts(input: [Entry]) -> [Int] {
        let week1 = input.filter({ $0.weekOfMonth == 1 }).map({ $0.amount }).reduce(0, +)
        let week2 = input.filter({ $0.weekOfMonth == 2 }).map({ $0.amount }).reduce(0, +)
        let week3 = input.filter({ $0.weekOfMonth == 3 }).map({ $0.amount }).reduce(0, +)
        let week4 = input.filter({ $0.weekOfMonth == 4 }).map({ $0.amount }).reduce(0, +)
        
        return [week1, week2, week3, week4]
    }
    
    func getYearlyAmounts(input: [Entry]) -> [Int] {
        let q1 = input.filter({ $0.quarter == 1 }).map({ $0.amount }).reduce(0, +)
        let q2 = input.filter({ $0.quarter == 2 }).map({ $0.amount }).reduce(0, +)
        let q3 = input.filter({ $0.quarter == 3 }).map({ $0.amount }).reduce(0, +)
        let q4 = input.filter({ $0.quarter == 4 }).map({ $0.amount }).reduce(0, +)
        
        return [q1, q2, q3, q4]
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
            get { if amountSet.count == 1 { return amountSet.first ?? 0 } else {
                return amountSet.max() ?? 0 }
            }
        }
        static var med: Int { if amountSet.count == 1 { return amountSet.first ?? 0 } else {
            return amountSet.median() ?? 0 }
        }
        
        static var min: Int { if amountSet.count == 1 { return amountSet.first ?? 0 } else {
            return amountSet.min() ?? 0 }
        }
    }
}
