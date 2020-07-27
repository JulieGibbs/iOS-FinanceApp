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
    
    var bottomStackView = GRStackView()
    
    var graphPointsCount: Int = 0
    
    var graphPointsMaxValue: Int {
        get { return graphPoints.max() ?? 0 }
    }
    
    var graphPoints = [Int]()
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        
        let height = rect.height
        
        let graphHeight = height - Constants.topBorder - Constants.bottomBorder
        
        // MARK: - Gradient
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadius)
        
        path.addClip()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: .init(rawValue: 0))
        
        // MARK: - Graph Points
        let margin = Constants.margin
        
        let graphWidth = width - margin * 2
        
        let xPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 10
        }
        
        let yPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(self.graphPointsMaxValue) * graphHeight
            return graphHeight + Constants.topBorder - y
        }
        
        // MARK: - Paths
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let graphPath = UIBezierPath()
        
        if graphPoints.count > 0 {
            graphPath.move(to: CGPoint(x: xPoint(0), y: yPoint(graphPoints[0])))
            print("Graph Path moved to point \(graphPath.currentPoint)")
        }
        
        if graphPoints.count > 0 {
            for i in 1..<graphPoints.count {
                let nextPoint = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
                graphPath.addLine(to: nextPoint)
                print("Graph Path moved to point \(graphPath.currentPoint)")
            }
        }
        
        context.saveGState()
        
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        clippingPath.addLine(to: CGPoint(x: xPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: xPoint(0), y: height))
        clippingPath.close()
        clippingPath.addClip()
        
        let highestYPoint = yPoint(graphPointsMaxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        
        context.restoreGState()
        
        graphPath.lineWidth = 1.5
        graphPath.stroke()
        
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point, size: CGSize(
                        width: Constants.circleDiameter, height: Constants.circleDiameter)
                )
            )
            circle.fill()
        }
        
        // MARK: - Lines
        let linesPath = UIBezierPath()
        
        
        linesPath.move(to: CGPoint(x: Constants.margin + 10, y: Constants.topBorder + graphHeight / 2))
        linesPath.addLine(to: CGPoint(x: width - Constants.margin + 10, y: Constants.topBorder + graphHeight / 2))
        
        linesPath.move(to: CGPoint(x: Constants.margin + 10, y: height - Constants.bottomBorder))
        linesPath.addLine(to: CGPoint(x: width - Constants.margin + 10, y: height - Constants.bottomBorder))
        
        let lineColor = UIColor(white: 1.0, alpha: 0.5)
        lineColor.setStroke()
        
        linesPath.lineWidth = 1.0
        linesPath.stroke()
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
        
        static let circleDiameter: CGFloat = 5.0
    }
}
