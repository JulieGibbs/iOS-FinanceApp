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

extension Publisher {
    static func +=(lhs: Publisher, rhs: Observer) {
        add(observer: rhs)
    }
    
    static func +=(lhs: Publisher, rhs: [Observer]) {
        rhs.forEach { add(observer: $0) }
    }
    
    static func --=(lhs: Publisher , rhs: Observer) {
        remove(observer: rhs)
    }
    
    static func --=(lhs: Publisher, rhs: [Observer]) {
        rhs.forEach { remove(observer: $0) }
    }
    
    static func -=(lhs: Publisher, rhs: Observer) {
        dispose(observer: rhs)
    }
    
    static func -=(lhs: Publisher, rhs: [Observer]) {
        rhs.forEach { remove(observer: $0) }
    }
    
    static func ~>(lhs: Publisher, rhs: Transmittable) {
        send(transmission: rhs)
    }
    
    static func ~>(lhs: Publisher, rhs: [Transmittable]) {
        rhs.forEach { send(transmission: $0) }
    }
}
