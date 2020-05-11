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

typealias Section = SectionType

// MARK: - Global Variables
var realm = try! Realm()
var entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
var currentBalance: Int = realm.objects(Entry.self).sum(ofProperty: "amount")
let notificationCenter = NotificationCenter.default

// MARK: - Class for Entries
class Entry: Object {
    // MARK: - Persisted Properties
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var amount: Int = 0
    @objc dynamic var date: Date?
    @objc dynamic var category: String?
    @objc dynamic var entryType: String?
    
    // MARK: - Custom Init to Add an Entry
    convenience init(id: String, name: String, amount: Int, date: Date, category: String, entryType: String?) {
        self.init()
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.entryType = entryType
    }
    
    // MARK: - Description
    override var description: String {
        get {
            return """
            id: \(id ?? "");
            name: \(name ?? "");
            amount: \(amount);
            created: \(date ?? Date());
            type: \(entryType ?? "");
            category: \(category ?? "").
            """
        }
    }
}

// MARK: - Class for Data & Realm Management
class DataManager {
    // MARK: - Singleton
    static let shared = DataManager()
    
    
    
    // MARK: - Realm Administration
    class func search(searchTerm: String? = nil) -> Results<Entry> {
        return realm.objects(Entry.self)
            .filter("category contains [c] %@", searchTerm ?? "")
            .sorted(byKeyPath: "amount", ascending: false)
    }
    
    class func writeToRealm(_ input: Entry) {
        realm.beginWrite()
        realm.add(input)
        
        do { try realm.commitWrite() }
        catch { print(error) }
        
        notificationCenter.post(name: .entryAddSuccess, object: nil)
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
        let categories = Array(data)
        var dict: [String:Int] = [:]
        
        categories.forEach {
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

enum SectionType: Hashable, CaseIterable {
    case main
}
