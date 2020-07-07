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
            $0.amount < 0 ? Expenses.amountSet.append($0.amount * -1) : Incomes.amountSet.append($0.amount)
        }
        
        let data = [(Expenses.min, Expenses.med, Expenses.max), (Incomes.min, Incomes.med, Incomes.max)]
        
        Publisher.send(transmission: Transmission(message: data))
        print(Expenses.min, Expenses.med, Expenses.max)
        print(Incomes.min, Incomes.med, Incomes.max)
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

struct Incomes {
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
