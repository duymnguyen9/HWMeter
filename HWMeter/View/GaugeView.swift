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
    let startAngle: CGFloat = CGFloat.pi * 0.8
    
    // MARK: - Properties
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let valueLabel = UILabel()
    let title = UILabel()
    let subtitle = UILabel()
    let gradient = CAGradientLayer()
    let unitLabel = UILabel()
    
    let valueLabelColor = UIColor.white
    let titleColor = UIColor.white.withAlphaComponent(0.87)
    let subtitleColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
    let gaugeColor = UIColor.black
    
    var gradientColors = Theme.gradientColors2
    
    var constraintList : [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    var sensorGauge: SensorGauge = SensorGauge(temp: "~", usage: 0.0, sensorType: .CPU) {
        didSet {
            valueLabel.text = sensorGauge.sensorTemp
            title.text = sensorGauge.sensorName
            if sensorGauge.sensorName == "GPU" {
                gradient.colors = Theme.gradientColors1
            } else {
                gradient.colors = Theme.gradientColors2
            }
        }
        willSet {
            self.setSensorUsage(to: CGFloat(Float(newValue.sensorUsage)), from: CGFloat(sensorGauge.sensorUsage))
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        valueLabel.text = "°"
        title.text = "CPU"
        subtitle.text = "Temp"
        unitLabel.text = "°"
        
        setUpLabel()
        setUpGauge()
        
        constraintList = [
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -bounds.width / 50),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.05 * bounds.width),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.05 * bounds.width),
            
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -0.015 * bounds.height),
            
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        //        gaugeViewLayout()
        super.layoutSubviews()
        gaugeViewLayout()
    }
    
    func setUpGauge() {
        trackLayer.strokeColor = Theme.frontColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        shapeLayer.strokeColor = gaugeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        gradient.locations = [0.2, 0.7]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = shapeLayer
        
        layer.addSublayer(gradient)
    }
    
    func setUpLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textColor = valueLabelColor
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = titleColor
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.textColor = subtitleColor
        
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.textColor = valueLabelColor
        
        addSubview(valueLabel)
        addSubview(title)
        addSubview(subtitle)
        addSubview(unitLabel)
        
    }
    
    func gaugeViewLayout() {
        let valueLabelfontHeight = bounds.width * 0.225
        
        valueLabel.font = UIFont.boldSystemFont(ofSize: valueLabelfontHeight)
        title.font = UIFont.boldSystemFont(ofSize: valueLabelfontHeight * 0.7)
        subtitle.font = UIFont.systemFont(ofSize: bounds.width / 12)
        unitLabel.font = UIFont.boldSystemFont(ofSize: valueLabelfontHeight * 0.75)
        
        let lineWidth = bounds.width / 15
        let centerPoint = CGPoint(x: bounds.width / 2,
                                  y: bounds.width / 2)
        let radius = (bounds.width / 2) - (lineWidth * 2)
        
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: CGFloat.pi - startAngle, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.lineWidth = lineWidth * 0.6
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = lineWidth
        
        gradient.frame = layer.bounds
        
        NSLayoutConstraint.deactivate(constraintList)
        
        constraintList = getConstraintList()
        
        NSLayoutConstraint.activate(constraintList)
        //        layoutIfNeeded()
    }
    
    func getConstraintList() -> [NSLayoutConstraint] {
        return [
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -bounds.width / 50),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.05 * bounds.width),
            
            
            
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            //        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.05 * bounds.width),
            title.topAnchor.constraint(equalTo: subtitle.bottomAnchor),
            
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
        ]
    }
    
    
    func setSensorUsage(to newValue: CGFloat, from oldValue: CGFloat) {
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
