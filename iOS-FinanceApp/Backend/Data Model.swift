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
/**
 '@objcMembers' exposes all class members, extensions, subclasses and their extensions to Objective-C code
 this adversely affects performance, thus not recommended
 ~> '@objc' used instead (does the same thing but for the individual member of the class)
 */
class Entry: Object {
    // MARK: - Entry Persisted Properties
    enum Property: String {
        case id, name, amount, date, category, entryType, creationStamp
    }
    
    /**
     'dynamic' engages the dynamic method dispatch to deal with the property (theory below)
     - method dispatch: mechanism that selects the appropriate method implementation to be called, breaks down in following types:
     - dynamic dispatch: engaged on runtime, thus some overhead, breaks down in two types:
     - table (virtual) dispatch: creates the witness (virtual) table (an array of function pointers) ~> looks up appropriate implemetation address. Performs in 3 steps:
     (1) read the pointer address,
     (2) jump to the address location,
     (3) perform instruction (faster than message dispatch)
     - message dispatch: most dynamic way of invocation, it's behavior can be altered at runtime (method swizzling),
     - static (direct) dispatch: instruction locations detected @ compile time, compiler accesses instruction directly (fast, but slower than inline dispatch) so no overhead ar run time bc func overriding is not allowed in this case ~> no need to make a table
     - inline dispatch (fastest): (@inline) - inlining the code into the dispatch [NEEDS CLARIFICATION]
     */
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var amount: Int = 0
    @objc dynamic var date: Date?
    @objc dynamic var strDate: String {
        Butler.createDateFormatter(dateStyle: .medium, timeStyle: .none).string(from: date!)
    }
    @objc dynamic var category: String?
    @objc dynamic var entryType: String?
    @objc dynamic var creationStamp: String?
    
    // MARK: - Custom Init to Add an Entry
    /**
     convenience init - secondary supporting initializer [SOMEHOW NOW THIS IS THE ONLY WAY TO INIT REALM INSTANCE ~> NEEDS CLARIFICATION]
     */
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
    /*
     can be used to edit some of the object's property ~> EntryInsertion
     
     let person = MyPerson()
     person.personID = "My-Primary-Key"
     person.name = "Tom Anglade"
     
     Update `person` if it already exists, add it if not.
     
     let realm = try! Realm()
     try! realm.write {
     realm.add(person, update: true)
     }
     
     [CONSIDER IMPLEMENTATION]
     */
    override static func primaryKey() -> String {
        return Entry.Property.id.rawValue
    }
}

// MARK: - Class for Categories
class Category: Object {
    // MARK: - Category Persistent Properties
    enum Property: String {
        case id, name
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String?
    
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
    override static func primaryKey() -> String? {
        return Category.Property.name.rawValue
    }
}

// MARK: - Class for Data & Realm Management
final /* 'final' increases performance as static diapatch comes in*/ class DataManager {
    // MARK: - Realm Administration (+ CRUD Methods)
    /*
     'static func'prevents overriding thus statc dispatch is engaged and performance is gained
     'keypath' accessor obtains any instance property as a separate value; in this case (see method signature) it provides read-only access to the property "amount" (Entry/ Amount)
     */
    static func search(searchTerm: String? = nil) -> Results<Entry> {
        return realm.objects(Entry.self)
            .filter("category contains [c] %@", searchTerm ?? "")
            .sorted(byKeyPath: "amount", ascending: false)
    }
    
    static func writeToRealm(_ input: Object) {
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
    
    static func deleteFromRealm(_ input: Entry) {
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
    
    // MARK: - Graph View Data Source
    static func getGraphDataSource(timeFrame: TimeFrame, input data: Results<Entry>) {
        switch timeFrame {
        case .day:
            let today = Butler.createDateFormatter(dateStyle: .medium, timeStyle: .none).string(from: Date())
            print(entries.filter({ $0.strDate == today }))
        case .week:
            let dayFloor = Date(timeIntervalSinceNow: -7.0)
        
        case .month: break
        case .year: break
        case .all: break
        default: break
        }
    }
}

// MARK: - Categories Data Source
struct CategoryTotal /*: Hashable, Equatable*/ {
    let name: String
    let balance: Int
    let uuid = UUID()
}
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uuid)
//    }
//
//    static func ==(lhs: CategoryTotal, rhs: CategoryTotal) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//
//    func contains(query: String) -> Bool {
//        guard !query.isEmpty else { return true }
//
//        return name.lowercased().contains(query.lowercased())
//    }

enum TimeFrame {
    case day, week, month, year, all }
