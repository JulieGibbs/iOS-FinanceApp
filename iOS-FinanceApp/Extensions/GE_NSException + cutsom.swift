//
//  NSException + cutsom.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 03.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

extension NSExceptionName {
    static var shouldNeverHappenException: NSExceptionName {
        return.init("com.exc.this.should.never.happen")
    }
}
