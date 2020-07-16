//
//  LineGraphView.swift
//  iOS-FinanceApp
//
//  Created by Dmitry Aksyonov on 31.05.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import UIKit

class GRLineView: UIView {
    // MARK: - Gradient
    var gradientStartColor: UIColor = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.4117647059, alpha: 1)
    var gradientEndColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.6980392157, blue: 0.4392156863, alpha: 1)
    
    var titleLabel = UILabel()
    
    var totalLabel = UILabel()
    
    var maxLabel = UILabel()
    
    var medLabel = UILabel()
    
    var minLabel = UILabel()
    
    var bottomStackView = GRStackView()
    
    var graphPointsCount: Int = 0
    
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
        
        // MARK: - Lines
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
        
        // MARK: - Graph Points
        let margin = height - Constants.bottomBorder
        let graphWidth = width - margin * 2
        let xPoint = { (column: Int) -> CGFloat in
            return CGFloat.zero
        }
        
        // MARK: - Paths
        
        let incomesPath = UIBezierPath()
        let expensesPath = UIBezierPath()
    }
    
    override func didMoveToSuperview() {
        setupSelf()
        addLabels()
        constrainSelf()
        setupStackView()
        constrainLabels()
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
    
    func addLabels() {
        titleLabel = UILabel(frame: CGRect(
            x: 10.0,
            y: 5.0,
            width: 100,
            height: 15))
        setupLabel(inputLabel: titleLabel, labelText: "Profit & Loss Breakdown", fontString: "Avernir Next Regular", fontSize: 15)
        self.addSubview(titleLabel)
        
        totalLabel = UILabel(frame: CGRect(
            x: 10.0,
            y: 12.0,
            width: 100,
            height: 40))
        setupLabel(inputLabel: totalLabel, labelText: "Total:", fontString: "Avernir Next Regular", fontSize: 15)
        self.addSubview(totalLabel)
        
        maxLabel = UILabel(frame: CGRect(
            x: 10.0,
            y: 47.5,
            width: 100,
            height: 100))
        setupLabel(inputLabel: maxLabel, labelText: "Max", fontString: "Avernir Next Regular", fontSize: 15)
        self.addSubview(maxLabel)
        
        medLabel = UILabel(frame: CGRect(
            x: 10.0,
            y: 115,
            width: 100,
            height: 100))
        setupLabel(inputLabel: medLabel, labelText: "Med", fontString: "Avernir Next Regular", fontSize: 15)
        self.addSubview(medLabel)
        
        minLabel = UILabel(frame: CGRect(
            x: 10.0,
            y: 177.5,
            width: 100,
            height: 100))
        setupLabel(inputLabel: minLabel, labelText: "Min", fontString: "Avernir Next Regular", fontSize: 15)
        self.addSubview(minLabel)
    }
    
    func setupLabel(inputLabel: UILabel, labelText: String, fontString: String, fontSize: CGFloat) {
        inputLabel.text = "\(labelText)"
        inputLabel.font = UIFont(name: fontString, size: fontSize)
        inputLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        inputLabel.font = inputLabel.font.withSize(fontSize)
        inputLabel.resizeToText()
    }
    
    func constrainLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        medLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let safeArea = safeAreaLayoutGuide
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            
            totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            
            maxLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 7.61),
            maxLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            
            medLabel.topAnchor.constraint(equalTo: maxLabel.bottomAnchor, constant: 48),
            medLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            
            minLabel.topAnchor.constraint(equalTo: medLabel.bottomAnchor, constant: 46),
            minLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
        ]
        
        constraints.forEach({ $0.isActive = true })
    }
    
    func setupStackView() {
        bottomStackView = GRStackView(frame: CGRect(x: 10.0, y: 180, width: 100, height: 100))
        self.addSubview(bottomStackView)
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
