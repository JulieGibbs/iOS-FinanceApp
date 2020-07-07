//
//  Information.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

@objc protocol Transmittable: class {
    @objc optional var anyData: Any { get set }
    @objc optional var sideLabelsData: [[Int]] { get set }
}
