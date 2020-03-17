//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

final class Expense: Object {
    @objc dynamic var expenseName = ""
    @objc dynamic var expenseAmount = 0
    @objc dynamic var expenseDate: Date?
}

final class ExpensesList: Object {
    @objc dynamic var id = ""
    let expenses = List<Expense>()
}
