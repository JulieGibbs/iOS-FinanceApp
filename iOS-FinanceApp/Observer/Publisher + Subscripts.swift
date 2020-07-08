//
//  Observer + Subscripts.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension Publisher {
    public static subscript(index: Int) -> Observer? {
        get {
            guard index > -1, index < observers.count else {
                return nil
            }
            return observers[index].value
        }
    }
    
    public static subscript(observer: Observer) -> Int? {
        get {
            guard let index = observers.firstIndex(where: { $0.value === observer }) else {
                return nil
            }
            return index
        }
    }
}
