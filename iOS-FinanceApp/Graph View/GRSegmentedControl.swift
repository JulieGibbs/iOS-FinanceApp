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
    
    @objc dynamic var segIndex: Int = 0
        
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
            
            constraints.forEach { $0.isActive = true }
        }
    }
    
    override func didMoveToSuperview() {
        setup(input: items)
        constrain()
        
        addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
    }
    
    @objc func segmentTapped(_ sender: UISegmentedControl) {
        let graphDataSource = GraphDataSource()
        
        switch sender.selectedSegmentIndex {
        case 0:
            graphDataSource.getTimeframeData(timeFrame: .day, cutOff: DateConstants.today)
            
            segIndex = sender.selectedSegmentIndex
            print("\nGRSegemtedControl is now at \(segIndex) index.\n")
        case 1:
            graphDataSource.getTimeframeData(timeFrame: .week, cutOff: DateConstants.weekFloor)
            
            segIndex = sender.selectedSegmentIndex
            print("\nGRSegemtedControl is now at \(segIndex) index.\n")
        case 2:
            graphDataSource.getTimeframeData(timeFrame: .month, cutOff: DateConstants.monthFloor)
            
            segIndex = sender.selectedSegmentIndex
            print("\nGRSegemtedControl is now at \(segIndex) index.\n")
        case 3:
            graphDataSource.getTimeframeData(timeFrame: .year, cutOff: DateConstants.yearFloor)
            
            segIndex = sender.selectedSegmentIndex
            print("\nGRSegemtedControl is now at \(segIndex) index.\n")
        default:
            print(entries)
            
            segIndex = sender.selectedSegmentIndex
            print("\nGRSegemtedControl is now at \(segIndex) index.\n")
        }
    }
}

enum GRSegmetedSelection {
    case day, week, month, year, all
}
