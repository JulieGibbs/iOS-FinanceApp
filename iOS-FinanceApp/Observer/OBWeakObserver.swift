//
//  WeakObserver.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

final class WeakObserver {
    weak var value: Observer?
    
    init(_ value: Observer) {
        self.value = value
    }
}
