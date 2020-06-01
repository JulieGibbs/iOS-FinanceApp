//
//  GraphViewController.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 16.03.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewController: UIViewController {
    let segmentedControl = UISegmentedControl()
    let lineGraphView = LineGraphView()
    let pieChartView = PieChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "Day", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Week", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Month", at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: "Quarter", at: 3, animated: true)
        segmentedControl.insertSegment(withTitle: "Year", at: 4, animated: true)
    }
    func setupLineGraphView() {}
    func setupPieChartView() {}
}
