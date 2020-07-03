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
    static let today = Date()
    static let weekFloor = today.addingTimeInterval(-7 * 24 * 60 * 60)
    static let monthFloor = today.addingTimeInterval(-30 * 24 * 60 * 60)
    static let yearFloor = today.addingTimeInterval(-365 * 24 * 60 * 60)
}
