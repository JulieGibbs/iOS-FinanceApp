//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Realm Global Variables
var realm = try! Realm()
let tableEntries = try! Realm().objects(Entry.self).sorted(byKeyPath: "date", ascending: true) // ??
let categoriesSum = try! Realm().objects(Entry.self).map({ $0.category })
let allEntries = try! Realm().objects(Entry.self).sorted(byKeyPath: "date", ascending: false) // ??

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

class EntriesManager {
    class func mapCategories(from data: Results<Entry>) -> [Dictionary<String, Int>.Element] {
        let categories = Array(data)
        var dict: [String:Int] = [:]
        
        categories.forEach {
            if let current = dict[$0.category!] {
                dict[$0.category!] = current + $0.amount
            } else {
                dict[$0.category!] = $0.amount
            }
        }
        return dict.sorted { $0 < $1 }
    }
}
