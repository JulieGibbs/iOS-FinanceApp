//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Задача - реализовать базовую модель данных, реализующую основной функционал, а именно:
 - хранение доходов и затрат
 - калькуляцию тотальных доходов и затрат
 - вывод баланса
 
 далее комменты идут согласно каждому важному элементу модели
 
 посмотите на AppDelegate - там созданы базовые тесты, по ним видно, что вроде как работает. брейкпоинт на строчке 30 - баланс = 2520, что вроде правильно
 */

class Entry: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var amount: Int = 0
    @objc dynamic var date: Date?
    var isExpense: Bool = false
    
    // использован convenience init, потому что ругался компилятор - задумка в том, чтобы инициализировать новый объект для добавления его в массив
    convenience init(name: String, amount: Int, date: Date, isExpense: Bool) {
        self.init()
        self.name = name
        self.amount = amount
        self.date = date
        self.isExpense = isExpense
    }
}

class EntriesManager: Object {
    @objc dynamic var debit: Int = 0
    @objc dynamic var credit: Int = 0
    @objc dynamic var balance: Int = 0
    let entries = List<Entry>()
    
    func addTransaction(name: String, amount: Int, date: Date, isExpense: Bool) {
        let transaction = Entry(name: name, amount: amount, date: date, isExpense: isExpense)
        
        if transaction.isExpense == true {
            transaction.amount = transaction.amount * -1
            entries.append(transaction)
        } else {
            entries.append(transaction)
        }
    }
    
    func calculateTotals() {
        for item in entries {
            if item.isExpense == false {
                debit += item.amount
            } else { credit += item.amount }
        }
        
        balance = debit + credit
    }
}
