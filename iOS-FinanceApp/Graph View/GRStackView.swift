//
//  GRStackView.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 07.07.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class GRStackView: UIStackView {
    var stackViewLabels: [UILabel] = (1...7).map { _ in
        UILabel()
    }
    
    let labelTexts = [
        ["00:00", "03:00", "06:00", "09:00"],
        ["S", "M", "T", "W", "T", "F", "S"],
        ["W1", "W2", "W3", "W4"],
        ["Q1", "Q2", "Q3", "Q4"],
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        
    }
    
    func setupSelf() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
    }
    
}
