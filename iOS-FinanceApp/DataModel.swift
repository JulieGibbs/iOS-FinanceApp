//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    @objc dynamic var name: String?
    @objc dynamic var amount: Int = 0
    @objc dynamic var date: Date?
    @objc dynamic var category: String?
    @objc dynamic var entryType: String?
    
    convenience init(name: String, amount: Int, date: Date, category: String, entryType: String?) {
        self.init()
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.entryType = entryType
    }
}

class EntriesManager: Object {
    @objc dynamic var debit: Int = 0
    @objc dynamic var credit: Int = 0
    @objc dynamic var balance: Int = 0
    let entries = List<Entry>()
    
//    func addTransaction(name: String, amount: Int, date: Date, category: String, isExpense: Bool) {
//        let transaction = Entry(name: name, amount: amount, date: date, category: category, isExpense: isExpense)
//
//        if transaction.isExpense == true {
//            transaction.amount = transaction.amount * -1
//            entries.append(transaction)
//        } else {
//            entries.append(transaction)
//        }
//    }
    
//    func calculateTotals() {
//        for item in entries {
//            if item.isExpense == false {
//                debit += item.amount
//            } else { credit += item.amount }
//        }
//
//        balance = debit + credit
//    }
}
