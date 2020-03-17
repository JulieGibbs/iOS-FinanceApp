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


/**
 Класс, который хранит данные о затрате:
 - наименование
 - сумма
 - дата
 */
class Expense: Object {
    @objc dynamic var expenseName: String = ""
    @objc dynamic var expenseAmount: Int = 0
    @objc dynamic var expenseDate: Date?
    
    // использован convenience init, потому что ругался компилятор - задумка в том, чтобы инициализировать новый объект для добавления его в массив
    convenience init(name: String, amount: Int, date: Date) {
        self.init()
        self.expenseName = name
        self.expenseAmount = amount
        self.expenseDate = date
    }
}

/**
 Такой же класс, но с доходом
 */
class Income: Object {
    @objc dynamic var incomeName = ""
    @objc dynamic var incomeAmount = 0
    @objc dynamic var incomeDate: Date?
    
    convenience init(name: String, amount: Int, date: Date) {
        self.init()
        self.incomeName = name
        self.incomeAmount = amount
        self.incomeDate = date
    }
}

/**
 Класс, объединяющий в себе:
 - перечни доходов и затрат
 - методы добавления доходов и затрат
 - методы подсчета тотальных дохода, затрат и вывода баланса
 */
class Transaction {
    let expenses = List<Expense>()
    let incomes = List<Income>()
    var balance: Int {
        get { return calculateDebit() + calculateCredit()}
    }
    
    func addIncome(name: String, amount: Int, date: Date) {
        let newIncome = Income(name: name, amount: amount, date: date)
        incomes.append(newIncome)
    }
    
    func addExpense(name: String, amount: Int, date: Date) {
        let newExpense = Expense(name: name, amount: amount, date: date)
        expenses.append(newExpense)
    }
    
    func calculateDebit() -> Int {
        var total = 0
        for item in incomes where item.incomeAmount > 0 {
            total += item.incomeAmount
        }
        
        return total
    }
    
    func calculateCredit() -> Int {
        var total = 0
        for item in expenses where item.expenseAmount > 0 {
            total += item.expenseAmount
        }
        
        return -total 
    }
}

/**
 какие есть идеи по развитию:
 - избавиться от циклов - заменить на замыкания
 */
