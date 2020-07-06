//
//  File.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

class Subject {
    
    final class WeakObserver {
        weak var value: Observable?
        
        init(_ value: Observable) {
            self.value = value
        }
    }
    
    static var observers = [WeakObserver]()
    static var queue = DispatchQueue(label: "concurrentQueue", attributes:  .concurrent)
    
    class func add(observer: Observable) {
        queue.sync(flags: .barrier) {
            observers.append(WeakObserver(observer))
        }
    }
    
    class func remove(observer: Observable) {
        queue.sync(flags: .barrier) {
            guard let index = self[observer] else {
                return
            }
            observers.remove(at: index)
        }
    }
    
    class func send(transmission: Transmittable) {
        queue.sync {
            recycle()
            
            observers.forEach {
                $0.value?.notify(with: transmission)
            }
        }
    }
    
    class func dispose(observer: Observable) {
        queue.sync(flags: .barrier) {
            if let index = self[observer] {
                observers[index].value = nil
            }
        }
    }
    
    class func recycle() {
        for (index, element) in observers.enumerated().reversed() where element.value == nil {
            observers.remove(at: index)
        }
    }
}
