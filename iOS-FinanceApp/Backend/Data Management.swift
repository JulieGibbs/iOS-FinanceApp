//
//  Data Management.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 02.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

final /* 'final' increases performance as static diapatch comes in*/ class DataManager {
    // MARK: - Realm Administration (+ CRUD Methods)
    /**
     'static func'prevents overriding thus statc dispatch is engaged and performance is gained
     'keypath' accessor obtains any instance property as a separate value; in this case (see method signature) it provides read-only access to the property "amount" (Entry/ Amount)
     */
    static func search(searchTerm: String? = nil) -> Results<Entry> {
        return realm.objects(Entry.self)
            .filter("category contains [c] %@", searchTerm ?? "")
            .sorted(byKeyPath: "amount", ascending: false)
    }
    
    static func createEntry(_ input: Object) {
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
    
    static func deleteEntry(_ input: Entry) {
        realm.beginWrite()
        realm.delete(input)
        
        do { try realm.commitWrite() }
        catch { print(error) }
        
        notificationCenter.post(name: .entryRemoveSuccess, object: nil)
    }
    
    // MARK: - Migration Tools
    static func showSchemaVersion() -> UInt64 {
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
    
    static func migratePersistentStorage(schema version: @escaping () -> UInt64 = showSchemaVersion) {
        let config = Realm.Configuration(schemaVersion: version(), migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < version() {  }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Helpers for View and Data
    /**
     Algorithm that perform the categories mapping in the folowing way:
     - takes the queried entries from the datasource as a Results<Array> as a parameter;
     - transforms the data to the array;
     - for each element in data array:
     - if there is no such category yet in the dictionary – the algorithm assigns the amount value to the fresh category
     - if the category already exist – the algorithm adds the matched category's value to the total
     */
    static func mapCategories(from data: Results<Entry>) -> [Dictionary<String, Int>.Element] {
        let rawData = Array(data)
        var dict: [String:Int] = [:]
        
        rawData.forEach {
            /**
             accessing dictionary KV-pair element is performed via KEY as a subscript
             */
            if let current = dict[$0.category!] {
                dict[$0.category!] = current + $0.amount
            } else {
                dict[$0.category!] = $0.amount
                
            }
        }
        return dict.sorted { $0.value < $1.value }
    }
    
    static func generateId() -> String {
        return UUID().uuidString
    }
}
