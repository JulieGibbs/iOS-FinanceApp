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
    
    func matchEntry(timeFrame: TimeFrame, input data: Results<Entry> = entries, cutOff: Date) {
        data.forEach {
            $0.date! >= cutOff ? matchedEntries.append($0) : nil
        }
    }
    
    func splitAmounts(input: [Entry]) {
        input.forEach {
            $0.amount < 0 ? Expenses.amountSet.append($0.amount) : Incomes.amountSet.append($0.amount)
        }
        
        print(matchedEntries)
        print(Expenses.amountSet)
        print(Expenses.max)
        print(Expenses.med)
        print(Expenses.min)
        
        print(Incomes.amountSet)
        print(Incomes.max)
        print(Incomes.med)
        print(Incomes.min)
    }
}

struct Expenses {
    static var amountSet = [Int]()
    
    static var max: Int {
        get { amountSet.max()! }
    }
    static var med: Double {
        get { amountSet.median()! }
    }
    static var min: Int {
        get { amountSet.min()! }
    }
}

struct Incomes {
    static var amountSet = [Int]()
    
    static var max: Int {
        get { amountSet.isEmpty ? 0 : amountSet.max()! }
    }
    static var med: Double {
        get { amountSet.median()! }
    }
    static var min: Int {
        get { amountSet.min()! }
    }
}
