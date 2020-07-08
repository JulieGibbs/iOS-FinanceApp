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
    
    func addLabels(quantity: Int) {
        for label in stackViewLabels[0...quantity + 1] {
            label.font = UIFont.init(name: "Avenir Next Medium", size: 12)
            label.textColor = .white
            
            self.addArrangedSubview(label)
        }
    }
    
    func switchLabelsText(_case: Int) {
        mainLoop: for label in stackViewLabels {
            textLoop: for text in labelTexts[_case] {
                label.text = text
            }
        }
    }
    
    func changeContent(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            switchLabelsText(_case: 0)
            addLabels(quantity: 4)
        case 1:
            addLabels(quantity: 7)
            switchLabelsText(_case: 1)
        case 2:
            addLabels(quantity: 4)
            switchLabelsText(_case: 2)
        case 3:
            addLabels(quantity: 4)
            switchLabelsText(_case: 3)
        default:
            break
        }
    }
    
}
