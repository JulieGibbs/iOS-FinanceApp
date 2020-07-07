//
//  Side Labels Transmission.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 07.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

final class GRLabelsTransmission: Transmittable {
    var sideLabelsData: [[Int]]
    
    init(sideLabelsData: [[Int]]) {
        self.sideLabelsData = sideLabelsData
    }
}

