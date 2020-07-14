//
//  LineGraphView.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 31.05.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class GRLineView: UIView {
    var gradientStartColor: UIColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.4117647059, alpha: 1)
    var gradientEndColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.6980392157, blue: 0.4392156863, alpha: 1)
    
    var titleLabel = UILabel()
    var totalLabel = UILabel()
    var maxLabel = UILabel()
    var medLabel = UILabel()
    var minLabel = UILabel()
    
    let bottomStackView = GRStackView()
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let graphHeight = height - Constants.topBorder - Constants.bottomBorder
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadius)
        
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        context?.drawLinearGradient(gradient,
                                    start: startPoint,
                                    end: endPoint,
                                    options: .init(rawValue: 0))
        
        let linesPath = UIBezierPath()
        
        linesPath.move(to: CGPoint(x: Constants.margin + 10, y: Constants.topBorder))
        linesPath.addLine(to: CGPoint(x: width - Constants.margin + 10, y: Constants.topBorder))
        
        linesPath.move(to: CGPoint(x: Constants.margin + 10, y: Constants.topBorder + graphHeight / 2))
        linesPath.addLine(to: CGPoint(x: width - Constants.margin + 10, y: Constants.topBorder + graphHeight / 2))
        
        linesPath.move(to: CGPoint(x: Constants.margin + 10, y: height - Constants.bottomBorder))
        linesPath.addLine(to: CGPoint(x: width - Constants.margin + 10, y: height - Constants.bottomBorder))
        
        let lineColor = UIColor(white: 1.0, alpha: 0.5)
        lineColor.setStroke()
        
        linesPath.lineWidth = 1.0
        linesPath.stroke()
        
        let incomesPath = UIBezierPath()
        let expensesPath = UIBezierPath()
    }
    
    override func didMoveToSuperview() {
        setupSelf()
        setupLabels()
        constrainSelf()
    }
    
    func setupSelf() {
        backgroundColor = .clear
    }
    
    func constrainSelf() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = superview {
            let safeArea = superview.safeAreaLayoutGuide
            
            let constraints = [
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                heightAnchor.constraint(equalToConstant: 250)
            ]
            
            constraints.forEach { $0.isActive = true }
        }
    }
    
    func setupLabels() {
        titleLabel = UILabel(frame: CGRect(x: 10.0, y: 5.0, width: 100.0, height: 40.0))
        titleLabel.text = "Profit & Loss Breakdown"
        titleLabel.font = UIFont(name: "Avenir Next Regular", size: 9)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        totalLabel = UILabel(frame: CGRect(x: 10.0, y: 12.0, width: 100, height: 40))
        totalLabel.text = "Total:"
        totalLabel.font = UIFont(name: "Avenir Next Regular", size: 9)
        totalLabel.textColor = .white
        titleLabel.sizeToFit()
        self.addSubview(totalLabel)
        
        self.addSubview(maxLabel)
        maxLabel.text = "Max"
        maxLabel.font = UIFont(name: "Avenir Next Regular", size: 12)
        
        self.addSubview(medLabel)
        medLabel.text = "Med"
        medLabel.font = UIFont(name: "Avenir Next Regular", size: 12)
        
        self.addSubview(minLabel)
        minLabel.text = "Min"
        minLabel.font = UIFont(name: "Avenir Next Regular", size: 12)
    }
}

extension GRLineView {
    private struct Constants {
        static let viewWidth: CGFloat = 300.0
        static let viewHeight: CGFloat = 250.0
        static let cornerRadius = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 30.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 60.0
    }
}
