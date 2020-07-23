//
//  Timframes.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 02.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

enum TimeFrame {
    case day, week, month, year, all
}

struct DateConstants {
    static var today: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!
        }
    }
    
    static var weekFloor: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: today.addingTimeInterval(-7 * 24 * 60 * 60)))!
        }
    }
    
    static var monthFloor: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: today.addingTimeInterval(-30 * 24 * 60 * 60)))!
        }
    }
    
    static var yearFloor: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: today.addingTimeInterval(-365 * 24 * 60 * 60)))!
        }
    }
}
