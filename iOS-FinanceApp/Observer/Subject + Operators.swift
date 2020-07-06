//
//  Subject + Operators.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

infix operator --=
infix operator -=

extension Subject {
    static func +=(lhs: Subject, rhs: Observable) {
        add(observer: rhs)
    }
    
    static func +=(lhs: Subject, rhs: [Observable]) {
        rhs.forEach { add(observer: $0) }
    }
    
    static func --=(lhs: Subject , rhs: Observable) {
        remove(observer: rhs)
    }
    
    static func --=(lhs: Subject, rhs: [Observable]) {
        rhs.forEach { remove(observer: $0) }
    }
    
    static func -=(lhs: Subject, rhs: Observable) {
        dispose(observer: rhs)
    }
    
    static func -=(lhs: Subject, rhs: [Observable]) {
        rhs.forEach { remove(observer: $0) }
    }
    
    static func ~>(lhs: Subject, rhs: Transmittable) {
        send(transmission: rhs)
    }
    
    static func ~>(lhs: Subject, rhs: [Transmittable]) {
        rhs.forEach { send(transmission: $0) }
    }
}
