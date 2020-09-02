//
//  GaugeView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class CustomGaugeView: UIView {
    let startAngle: CGFloat = CGFloat.pi * 3 / 4
    let endAngle: CGFloat = CGFloat.pi / 4
    
    // MARK: - Properties

    let shapeLayer = CAShapeLayer()
    let valueLabel = UILabel()
    let title = UILabel()
    let subtitle = UILabel()
    let gradient = CAGradientLayer()
    
    let valueLabelColor = UIColor.white
    let titleColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
    let subtitleColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
    let trackColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
    let gaugeColor = UIColor.black
    
    var gradientColors = Theme.gradientColors2
    
    var sensorGauge: SensorGauge = SensorGauge(temp: "~", usage: 0.0, sensorType: .CPU) {
        didSet {
            valueLabel.text = sensorGauge.sensorTemp + "°"
            title.text = sensorGauge.sensorName
        }
        willSet {
            self.setSensorUsage(to: CGFloat(Float(newValue.sensorUsage)), from: CGFloat(sensorGauge.sensorUsage))
        }
    }
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGauge()
        setUpLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpGauge()
        setUpLabel()
    }
    
//    init(<#parameters#>) {
//        <#statements#>
//    }
//
    // Add Setup
    func setUpContainerView() {}
    
    func setUpGauge() {
        let lineWidth = bounds.width / 15
        let centerPoint = CGPoint(x: bounds.width / 2,
                                  y: bounds.width / 2)
        let radius = (bounds.width / 2) - (lineWidth * 2)
        
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth * 0.6
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = gaugeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0

        gradient.frame = layer.bounds
        gradient.colors = gradientColors
        gradient.locations = [0.2, 0.7]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = shapeLayer

        layer.addSublayer(gradient)
    }
    
    func setUpLabel() {
        valueLabel.text = "°"
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.225)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textColor = valueLabelColor
        
        title.text = "CPU"
        title.font = UIFont.boldSystemFont(ofSize: bounds.width / 8)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = titleColor
        
        subtitle.text = "Temp"
        subtitle.font = UIFont.systemFont(ofSize: bounds.width / 12)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.textColor = subtitleColor
        
        addSubview(valueLabel)
        addSubview(title)
        addSubview(subtitle)
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: bounds.width / 50),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.05 * bounds.width),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.1 * bounds.width),
            
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -0.015 * bounds.width)
        ])
    }
    
    func setSensorUsage(to newValue: CGFloat, from oldValue: CGFloat) {
//        print("to: \(newValue), from: \(oldValue)")
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationDuration(to: newValue, from: oldValue)
        animation.fromValue = oldValue
        animation.toValue = newValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock { [weak self] in
            self?.shapeLayer.strokeEnd = newValue
        }
        
        shapeLayer.add(animation, forKey: "gaugeAnimation")
        CATransaction.commit()
    }
    
    func animationDuration(to newValue: CGFloat, from oldValue: CGFloat) -> CFTimeInterval {
        let difference = abs(newValue - oldValue)
        return CFTimeInterval(difference)
    }
}
