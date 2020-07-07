//
//  GRSegmentedControl.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 28.06.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class GRSegmentedControl: UISegmentedControl {
    let items = ["All", "Year", "Month", "Week", "Day"]
    
    func setup() {
        for item in items {
            var index = 0
            insertSegment(withTitle: item, at: index, animated: true)
            index += 1
        }
        selectedSegmentIndex = 0
    }
    
    func constrain() {
        if let superview = superview {
            let safeArea = superview.safeAreaLayoutGuide
            
            translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
            ]
            
            constraints.forEach { constraint in
                constraint.isActive = true
            }
        }
    }
    
    override func didMoveToSuperview() {
        setup()
        constrain()
        
        addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        
        
    }
    
    @objc func segmentTapped(_ sender: UISegmentedControl) {
        let graphDataSource = GraphDataSource()
        
        switch sender.selectedSegmentIndex {
        case 0:
            graphDataSource.matchEntry(timeFrame: .day, cutOff: DateConstants.today)
            graphDataSource.splitAmounts(input: graphDataSource.matchedEntries)
            Publisher.send(transmission: GRSegmentedTransmission(selection: 0))
        case 1:
            graphDataSource.matchEntry(timeFrame: .week, cutOff: DateConstants.weekFloor)
            graphDataSource.splitAmounts(input: graphDataSource.matchedEntries)
        case 2:
            graphDataSource.matchEntry(timeFrame: .month, cutOff: DateConstants.monthFloor)
            graphDataSource.splitAmounts(input: graphDataSource.matchedEntries)
        case 3:
            graphDataSource.matchEntry(timeFrame: .year, cutOff: DateConstants.yearFloor)
            graphDataSource.splitAmounts(input: graphDataSource.matchedEntries)
        default:
            print(entries)
        }
    }
}

enum GRSegmetedSelection {
    case day, week, month, year, all
}
