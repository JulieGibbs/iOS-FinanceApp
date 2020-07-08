//
//  Data Source.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 02.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import RealmSwift

var realm = try! Realm()
var entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
var currentBalance: Int = realm.objects(Entry.self).sum(ofProperty: "amount")
