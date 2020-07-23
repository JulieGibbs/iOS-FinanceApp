//
//  String + Whitespaces.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 05.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension String {
    var doesContainWhitespacesAndNewLines: Bool {
        return (self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}
