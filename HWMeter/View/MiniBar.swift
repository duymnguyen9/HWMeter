//
//  miniBar.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/2/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class MiniBar: UIView {
    let title = UILabel()
    let fontSize: CGFloat = 20.0
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    var value : CGFloat = CGFloat(0.5) {
        didSet {
            shapeLayer.strokeEnd = value
        }
    }
    
    let trackColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
    var gaugeColor = UIColor.black
    var gradientColors = Theme.gradientColors1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        if GlobalConstants.isDebug {
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
        }
        title.text = "XXX"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(barColor: UIColor) {
        title.font = UIFont.systemFont(ofSize: bounds.height * 0.4, weight: .regular)
        title.textColor = UIColor.white
        title.textAlignment = .right
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        shapeLayer.strokeColor = barColor.cgColor
        
        layoutIfNeeded()
        labelLayout()
        barLayout()
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * GlobalConstants.miniBarValueWidthFactor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
//            title.topAnchor.constraint(equalTo: bottomAnchor, constant: 40),
        ])
    }
    
    func barLayout() {
        let lineWidth = bounds.height * GlobalConstants.barValueHeightFactor / 1.5
        
        let startX = bounds.width * (GlobalConstants.miniBarValueWidthFactor) + lineWidth

        let startY = bounds.height / 2
        let endX = bounds.width - (lineWidth / 2) - 0.025
        let endY = startY
        
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: startX, y: startY))
        barPath.addLine(to: CGPoint(x: endX, y: endY))
        
        shapeLayer.path = barPath.cgPath
//        shapeLayer.strokeColor = gaugeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.4
        
        trackLayer.path = barPath.cgPath
        trackLayer.strokeColor = Theme.frontColor.cgColor
        trackLayer.lineWidth = lineWidth * 0.75
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        
        gradient.frame = layer.bounds
        gradient.colors = gradientColors
        gradient.locations = [0.2, 0.7]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = shapeLayer
        
        layer.addSublayer(trackLayer)
                layer.addSublayer(shapeLayer)
//        layer.addSublayer(gradient)
        
        if GlobalConstants.isDebug {
            title.layer.borderWidth = 1
            title.layer.borderColor = UIColor.green.cgColor
        }
    }
}

