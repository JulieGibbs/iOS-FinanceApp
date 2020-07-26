//
//  GRTransmission.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 26.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation
import RealmSwift

class GRTransmission {
    static var shared: GRTransmission {
        let instance = GRTransmission()
        return instance
    }
    
    private init() {}
    
    var entries = [Entry]()
}
