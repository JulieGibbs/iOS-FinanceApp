//
//  DataModel.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - Global Variables
var realm = try! Realm()
var entries = realm.objects(Entry.self).sorted(byKeyPath: "creationStamp", ascending: false)
var currentBalance: Int = realm.objects(Entry.self).sum(ofProperty: "amount")
let notificationCenter = NotificationCenter.default

// MARK: - Class for Entries
@objcMembers class Entry: Object {
    // MARK: - Entry Persisted Properties
    enum Property: String {
        case id, name, amount, date, category, entryType, creationStamp
    }
    
    dynamic var id: String?
    dynamic var name: String?
    dynamic var amount: Int = 0
    dynamic var date: Date?
    dynamic var category: String?
    dynamic var entryType: String?
    dynamic var creationStamp: String?
    
    // MARK: - Custom Init to Add an Entry
    convenience init(id: String, name: String, amount: Int, date: Date, category: String, entryType: String?, ToC: String) {
        self.init()
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.entryType = entryType
        self.creationStamp = ToC
    }
    
    // MARK: - Entry Description
    override var description: String {
        get {
            return """
            \nid: \(id ?? "");
            name: \(name ?? "");
            amount: \(amount);
            date: \(date ?? Date());
            type: \(entryType ?? "");
            category: \(category ?? "");
            ToC: \(creationStamp ?? "").
            """
        }
    }
    
    // MARK: - Entry Primary Key
    override static func primaryKey() -> String {
        return Entry.Property.id.rawValue
    }
}

// MARK: - Class for Categories
@objcMembers class Category: Object {
    // MARK: - Category Persistent Properties
    enum Property: String {
        case id, name
    }
    
    dynamic var id = UUID().uuidString
    dynamic var name: String?
    
    // MARK: - Custom init to Add Category
    convenience init(id: String, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    // MARK: - Category Description
    override var description: String {
        get {
            return """
            \nid: \(id)
            name: \(name ?? "")
            """
        }
    }
    
    // MARK: - Category Primary Key
    override class func primaryKey() -> String? {
        return Category.Property.name.rawValue
    }
}

// MARK: - Class for Data & Realm Management
class DataManager {
    // MARK: - Realm Administration (+ CRUD Methods)
    class func search(searchTerm: String? = nil) -> Results<Entry> {
        return realm.objects(Entry.self)
            .filter("category contains [c] %@", searchTerm ?? "")
            .sorted(byKeyPath: "amount", ascending: false)
    }
    
    class func writeToRealm(_ input: Object) {
        realm.beginWrite()
        realm.add(input)
        
        do { try realm.commitWrite() }
        catch { print(error) }
        
        switch input {
        case is Entry:
            notificationCenter.post(name: .entryAddSuccess, object: nil)
        case is Category:
            notificationCenter.post(name: .categoryAddSuccess, object: nil)
        default:
            print("Somehow you managed to break it, congrats!")
        }
        
    }
    
    class func deleteFromRealm(_ input: Entry) {
        realm.beginWrite()
        realm.delete(input)
        
        do { try realm.commitWrite() }
        catch { print(error) }
        
        notificationCenter.post(name: .entryRemoveSuccess, object: nil)
    }
    
    // MARK: - Migration Tools
    class func showSchemaVersion() -> UInt64 {
        let schemaVersionCheck = Realm.Configuration()
        var version: UInt64 = 0
        
        do {
            version = try schemaVersionAtURL(schemaVersionCheck.fileURL!) as UInt64
            print("Schema version: \(version).")
        } catch {
            print(error)
        }
        return version
    }
    
    func migratePersistentStorage(schema version: @escaping () -> UInt64 = showSchemaVersion) {
        let config = Realm.Configuration(schemaVersion: version(), migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < version() {  }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Helpers for View and Data
    class func mapCategories(from data: Results<Entry>) -> [Dictionary<String, Int>.Element] {
        let rawData = Array(data)
        var dict: [String:Int] = [:]
        
        rawData.forEach {
            if let current = dict[$0.category!] {
                dict[$0.category!] = current + $0.amount
            } else {
                dict[$0.category!] = $0.amount
            }
        }
        return dict.sorted { $0.value < $1.value }
    }
    
    class func generateId() -> String {
        return UUID().uuidString
    }
}

// MARK: - Categories Data Source
struct CategoryTotal: Hashable, Equatable {
    let name: String
    let balance: Int
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func ==(lhs: CategoryTotal, rhs: CategoryTotal) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func contains(query: String) -> Bool {
        guard !query.isEmpty else { return true }
        
        return name.lowercased().contains(query.lowercased())
    }
}
