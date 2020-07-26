//
//  GraphViewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class GRViewController: UIViewController, Observer {
    let segmentedControl = GRSegmentedControl()
    
    let lineGraphView = GRLineView()
    
    let entryTypeToggle = GREntryTypeToggle()
    
    var transmittedData: Transmittable? = nil
    
    var kvoTokenSegmentedControl: NSKeyValueObservation?
    
    var kvoTokenGRStackView: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentedControl)
        view.addSubview(lineGraphView)
        view.addSubview(entryTypeToggle)
        
        lineGraphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        entryTypeToggle.topAnchor.constraint(equalTo: lineGraphView.bottomAnchor, constant: 20).isActive = true
        
        observe(segmentedControl: segmentedControl)
        
        Publisher.add(observer: self)
    }
    
    func receive(message: Transmittable) {
        print(message.description)
        
        transmittedData = message
        
//        lineGraphView.totalLabel.text = "Total: \(message.totalForIncome)"
//
//        var index = 0
//
//        for label in [lineGraphView.maxLabel, lineGraphView.medLabel, lineGraphView.minLabel] {
//            label.text = "\(message.incomeExtremums[index] )"
//            index += 1
//        }
    }
    
    func observe(segmentedControl: GRSegmentedControl) {
        kvoTokenSegmentedControl = segmentedControl.observe(\.segIndex, options: [.old, .new]) { (segmentedControl, change) in
            guard let segIndexNew = change.newValue, let segIndexOld = change.oldValue else { return }
            print("\nGRViewController is now aware that GRSegmentedControl is now at \(segIndexNew) index (was \(segIndexOld)).\n")
            
            switch segIndexNew {
            case 0:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 0, quantity: 6)
                
                self.lineGraphView.totalLabel.text = "Total: \(self.transmittedData?.totalForExpenses ?? 0)"
                
                self.lineGraphView.maxLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 1000)K"
                self.lineGraphView.medLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 2 / 1000)K"
                self.lineGraphView.minLabel.text = "\(self.lineGraphView.graphPoints.min() ?? 0 / 1000)K"
                
                self.lineGraphView.graphPoints = self.transmittedData!.dailyExpenseData.map { $0.1 }
                
                print("\nGraph points values are: \(self.lineGraphView.graphPoints)")
                print("\nGraph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
                
                self.lineGraphView.setNeedsDisplay()
            case 1:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 1, quantity: 7)
                
                self.lineGraphView.totalLabel.text = "Total: \(self.transmittedData?.totalForExpenses ?? 0)"
                
                self.lineGraphView.maxLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 1000)K"
                self.lineGraphView.medLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 2 / 1000)K"
                self.lineGraphView.minLabel.text = "\(self.lineGraphView.graphPoints.min() ?? 0 / 1000)K"
                
                self.lineGraphView.graphPoints = self.transmittedData!.weeklyExpenseData.map { $0.1 }
                
                print("\nGraph points values are: \(self.lineGraphView.graphPoints)")
                print("\nGraph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
                
                self.lineGraphView.setNeedsDisplay()
            case 2:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 2, quantity: 4)
                
               self.lineGraphView.totalLabel.text = "Total: \(self.transmittedData?.totalForExpenses ?? 0)"
                
                self.lineGraphView.maxLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 1000)K"
                self.lineGraphView.medLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 2 / 1000)K"
                self.lineGraphView.minLabel.text = "\(self.lineGraphView.graphPoints.min() ?? 0 / 1000)K"
                
                self.lineGraphView.graphPoints = self.transmittedData!.monthlyExpenseData.map { $0.1 }
                
                print("\nGraph points values are: \(self.lineGraphView.graphPoints)")
                print("\nGraph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
                
                self.lineGraphView.setNeedsDisplay()
            case 3:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 3, quantity: 4)
                
                self.lineGraphView.totalLabel.text = "Total: \(self.transmittedData?.totalForExpenses ?? 0)"
                
                self.lineGraphView.maxLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 1000)K"
                self.lineGraphView.medLabel.text = "\(self.lineGraphView.graphPointsMaxValue / 2 / 1000)K"
                self.lineGraphView.minLabel.text = "\(self.lineGraphView.graphPoints.min() ?? 0 / 1000)K"
                
                self.lineGraphView.graphPoints = self.transmittedData!.yearlyExpenseData.map { $0.1 }
                
                print("\nGraph points values are: \(self.lineGraphView.graphPoints)")
                print("\nGraph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
                
                self.lineGraphView.setNeedsDisplay()
            case 4:
                
                self.lineGraphView.totalLabel.text = "Total: \(self.transmittedData?.totalForExpenses ?? 0)"
                
                self.lineGraphView.graphPoints = entries.map({ $0.amount })
                
                print("\nGraph points values are: \(self.lineGraphView.graphPoints)")
                print("\nGraph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
                
                self.lineGraphView.setNeedsDisplay()
            default:
                break
            }
        }
        
        kvoTokenGRStackView = lineGraphView.bottomStackView.observe(
            \.arrangedSubviewsCount,
            options: [.old, .new]) { (subViewsCount, change) in
                guard let subViewsCountNew = change.newValue, let subViewsCountOld = change.oldValue else { return }
                print("\nGRViewController is aware of \(subViewsCountNew) arranged subviews in GRStackView (was \(subViewsCountOld)).")
                
                switch subViewsCountNew {
                case 6:
                    self.lineGraphView.graphPointsCount = 6
                    
                    print("\nGRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points.")
                case 7:
                    self.lineGraphView.graphPointsCount = 7
                   
                    print("\nGRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points.")
                case 4:
                    self.lineGraphView.graphPointsCount = 4
                    
                    print("\nGRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points.")
                default: break
                }
        }
    }
    
    deinit {
        kvoTokenSegmentedControl?.invalidate()
        kvoTokenGRStackView?.invalidate()
    }
    
    @objc func entryToggleTapped(_ sender: GREntryTypeToggle) {
        switch sender.selectedSegmentIndex {
        case 0: break
        case 1: break
        default: break
        }
    }
}
