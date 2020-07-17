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
        
        lineGraphView.totalLabel.text = "Total: \(message.totalForIncome)"
        
        var index = 0
        
        for label in [lineGraphView.maxLabel, lineGraphView.medLabel, lineGraphView.minLabel] {
            label.text = "\(message.incomeExtremums[index] ?? 0)"
            index += 1
        }
    }
    
    func observe(segmentedControl: GRSegmentedControl) {
        kvoTokenSegmentedControl = segmentedControl.observe(\.segIndex, options: [.old, .new]) { (segmentedControl, change) in
            guard let segIndexNew = change.newValue, let segIndexOld = change.oldValue else { return }
            print("VC: I see segmented control is now at \(segIndexNew) index. Was \(segIndexOld)")
            
            switch segIndexNew {
            case 0:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 0, quantity: 6)
                self.lineGraphView.graphPointsMaxValue = self.transmittedData?.dailyExpenseData.values.max() as! Int
                print("graph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
            case 1:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 1, quantity: 7)
                self.lineGraphView.graphPointsMaxValue = self.transmittedData?.weeklyExpenseData.values.max() as! Int
                print("graph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
            case 2:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 2, quantity: 4)
                self.lineGraphView.graphPointsMaxValue = self.transmittedData?.monthlyExpenseData.values.max() as! Int
                print("graph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
            case 3:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 3, quantity: 4)
                self.lineGraphView.graphPointsMaxValue = self.transmittedData?.yearlyExpenseData.values.max() as! Int
                print("graph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
            case 4:
                self.lineGraphView.graphPointsMaxValue = entries.map({ $0.amount }).max() as? Int ?? 0
                print("graph points max value is: \(self.lineGraphView.graphPointsMaxValue)")
            default:
                break
            }
        }
        
        kvoTokenGRStackView = lineGraphView.bottomStackView.observe(
            \.arrangedSubviewsCount,
            options: [.old, .new]) { (subViewsCount, change) in
                guard let subViewsCountNew = change.newValue, let subViewsCountOld = change.oldValue else { return }
                print("VC: I see there are \(subViewsCountNew) arranged subviews in GRStackView. Was \(subViewsCountOld)")
                
                switch subViewsCountNew {
                case 6:
                    self.lineGraphView.graphPointsCount = 6
                    print("GRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points")
                case 7:
                    self.lineGraphView.graphPointsCount = 7
                    print("GRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points")
                case 4:
                    self.lineGraphView.graphPointsCount = 4
                    print("GRLineView is ready to plot a path with \(self.lineGraphView.graphPointsCount) points")
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
