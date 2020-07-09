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
        data.forEach {
            $0.date! >= cutOff ? matchedEntries.append($0) : nil
        }
        
        matchedEntries.forEach {
            $0.amount > 0 ? income.append($0.amount) : expenses.append($0.amount * -1)
        }
        
        let labelIncomeData = [income.max(), income.median(), income.min()]
        let labelExpenseData = [expenses.max(), expenses.median(), expenses.min()]
        
        switch timeFrame {
        case .day:
            getDailyAmounts(input: matchedEntries)
        case .week:
            getWeeklyAmounts(input: matchedEntries)
        case .month:
            getMonthlyAmounts(input: matchedEntries)
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
            expensesTotal: expenses.reduce(0, +)))
    }
    
    func getDailyAmounts(input: [Entry]) {
        var (fourAM, eightAM, midday, fourPM, eightPM, midnight) = (0, 0, 0, 0, 0, 0)
        
        input.forEach {
            switch $0._time {
            case 0...4:
                fourAM += $0.amount
            case 5...8:
                eightAM += $0.amount
            case 9...12:
                midday += $0.amount
            case 13...16:
                fourPM += $0.amount
            case 17...20:
                eightPM += $0.amount
            case 21...24:
                midnight += $0.amount
            default:
                break
            }
        }
    }
    
    func getWeeklyAmounts(input: [Entry]) {
        var (sun, mon, tue, wed, thu, fri, sat) = (0, 0, 0, 0, 0, 0, 0)
        
        input.forEach {
            switch $0.weekDay {
            case "Sunday":
                sun += $0.amount
            case "Monday":
                mon += $0.amount
            case "Tuesday":
                tue += $0.amount
            case "Wednesday":
                wed += $0.amount
            case "Thursday":
                thu += $0.amount
            case "Firday":
                fri += $0.amount
            case "Saturday":
                sat += $0.amount
            default:
                break
            }
        }
    }
    
    func getMonthlyAmounts(input: [Entry]) {
        var (week1, week2, week3, week4) = (0, 0, 0, 0)
        
        input.forEach {
            switch $0.weekOfMonth {
            case 1:
                week1 += $0.amount
            case 2:
                week2 += $0.amount
            case 3:
                week3 += $0.amount
            case 4:
                week4 += $0.amount
            default: break
            }
        }
    }
    
    func getYearlyAmounts(input: [Entry]) {
        var (q1, q2, q3, q4) = (0, 0, 0, 0)
        
        input.forEach {
            switch $0.quarter {
            case 1:
                q1 += $0.amount
            case 2:
                q2 += $0.amount
            case 3:
                q3 += $0.amount
            case 4:
                q4 += $0.amount
            default:
                break
            }
        }
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
