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
    
    var transmittedData: AnyObject? = nil
    
    var kvoToken: NSKeyValueObservation?
    
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
        kvoToken = segmentedControl.observe(\.segIndex, options: [.old, .new]) { (segmentedControl, change) in
            guard let segIndexNew = change.newValue, let segIndexOld = change.oldValue else { return }
            print("VC: I see segmented control is now at \(segIndexNew) index. Was \(segIndexOld)")
            
            switch segIndexNew {
            case 0:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 0, quantity: 6)
            case 1:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 1, quantity: 7)
            case 2:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 2, quantity: 4)
            case 3:
                self.lineGraphView.bottomStackView.switchLabelsText(_case: 3, quantity: 4)
            default:
                break
            }
        }
    }
    
    deinit {
        kvoToken?.invalidate()
    }
    
    @objc func entryToggleTapped(_ sender: GREntryTypeToggle) {
        switch sender.selectedSegmentIndex {
        case 0: break
        case 1: break
        default: break
        }
    }
}

//    func setupLineGraphView() {
//        view.addSubview(lineGraphView)
//
//        let margins = view.layoutMarginsGuide
//
//        lineGraphView.backgroundColor = .clear
//        lineGraphView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 300, height: 250))
//
//        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
//
//        let graphViewConstraints = [
//            lineGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            lineGraphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32.5),
//            lineGraphView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//            lineGraphView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//            lineGraphView.heightAnchor.constraint(equalToConstant: 250)
//        ]
//
//        graphViewConstraints.forEach { constraint in
//            constraint.isActive = true
//        }
//
//        let graphLabels = (1...4).map { _ in UILabel() }
//
//
//        graphLabels[0].frame = CGRect(x: 15, y: 10, width: 40, height: 40)
//        graphLabels[0].text = "Profit and Loss Breakdown"
//        graphLabels[0].font = UIFont.init(name: "Avenir Next Bold", size: 12)
//        lineGraphView.addSubview(graphLabels[0])
//
//        var labelYPoint: CGFloat = 52.25
//
//        graphLabels[1...3].forEach { label in
//            label.frame = CGRect(x: 15, y: labelYPoint, width: 40, height: 40)
//            label.text = "XX"
//            labelYPoint += 65
//            label.font = UIFont.init(name: "Avenir Next", size: 12)
//            lineGraphView.addSubview(label)
//        }
//
//        let lineMargins = lineGraphView.layoutMarginsGuide
//
//        graphLabels.forEach { label in
//            label.textColor = .white
//            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//            label.textAlignment = .natural
//            label.sizeToFit()
//        }
//    }
//
//    func setupStackView() {
//
//        let margins = lineGraphView.layoutMarginsGuide
//
//
//        let stackView = UIStackView()
//        lineGraphView.addSubview(stackView)
//        stackView.frame = CGRect(x: 15, y: 100, width: 100, height: 100)
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillEqually
//        stackView.spacing = 25
//        stackView.sizeToFit()
//
//        let label = UILabel(frame: CGRect.zero)
//        var stackViewLabels: [UILabel] = (1...7).map { _ in UILabel()}
//        let labelTexts = [
//            ["00:00", "03:00", "06:00", "09:00"],
//            ["S", "M", "T", "W", "T", "F", "S"],
//            ["W1", "W2", "W3", "W4"],
//            ["Q1", "Q2", "Q3", "Q4"],
//            ["MIN", "MID", "MAX"]
//        ]
//
//        for label in stackViewLabels {
//            var i = 0
//            let weekTexts = labelTexts[1]
//            label.text = weekTexts[i]
//            label.font = UIFont.init(name: "Avenir Next Medium", size: 12)
//            label.textColor = .white
//            stackView.addArrangedSubview(label)
//            i += 1
//            print(label.text)
//        }
//
//        let constraints = [
//            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 34),
//            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant:  -15)
//        ]
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        constraints.forEach { constraint in
//            constraint.isActive = true
//        }
//    }
