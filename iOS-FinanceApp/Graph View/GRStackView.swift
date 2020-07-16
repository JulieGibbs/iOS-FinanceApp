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
        ["4AM", "8AM", "12AM", "4PM", "8PM", "12AM"],
        ["S", "M", "T", "W", "T", "F", "S"],
        ["W1", "W2", "W3", "W4"],
        ["Q1", "Q2", "Q3", "Q4"],
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        
        switchLabelsText(_case: 0, quantity: 6)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        constrainSelf()
    }
    
    func setupSelf() {
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
    }
    
    func switchLabelsText(_case: Int, quantity: Int) {
        arrangedSubviews.forEach({ removeArrangedSubview($0) })
        
        let arrangedSUbviewsToLoad = stackViewLabels[0...quantity - 1]
        let _labelTexts = labelTexts[_case]
        var i = 0
        
        for label in arrangedSUbviewsToLoad {
            
            
            label.text = "\(_labelTexts[i])"
            print(label.text)
            
            label.font = UIFont.init(name: "Avenir Next Regular", size: 7)
            label.font.withSize(6)
            label.textColor = .white
            
            i += 1
            
            addArrangedSubview(label)
        }
    }
    
    func constrainSelf() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = superview?.safeAreaLayoutGuide
        
        let constraints = [
            leadingAnchor.constraint(equalTo: safeArea!.leadingAnchor, constant: 40),
            bottomAnchor.constraint(equalTo: safeArea!.bottomAnchor, constant: -25),
            trailingAnchor.constraint(equalTo: safeArea!.trailingAnchor, constant: -20)
        ]
        
        constraints.forEach { $0.isActive = true }
    }
}
