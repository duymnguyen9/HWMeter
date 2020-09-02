//
//  BarView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/1/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

let barValueHeightFactor: CGFloat = 0.4
let barTitleHeightFactor: CGFloat = barValueHeightFactor * 0.7
let barValueWidthFactor: CGFloat = 0.3
let barPaddingFactor: CGFloat = 0.1

struct BarViewModel {
    var title: String
    var value: String
    var unit: String
    
    init(sensorInfo: SensorInfo) {
        self.title = sensorInfo.title
        self.value = sensorInfo.value
        self.unit = sensorInfo.unit
    }
}

class BarView: UIView {
    var barViewModel: BarViewModel = BarViewModel(sensorInfo: SensorInfo(title: "XXXXXX", value: "43.2", unit: "XXXXXX")) {
        didSet {
            let numberInString: String = String(barViewModel.value.prefix(2))
            valueLabel.text = numberInString + "%"
            setBarProgress(newValue: barViewModel.value)
        }
    }
    
    let valueLabel = UILabel()
    let title = UILabel()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    let trackColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
    let gaugeColor = UIColor.black
    var gradientColors = Theme.gradientColors2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        barLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        print("frame of Barview is: \(frame)")
        print("bounds of Barview is: \(bounds)")
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.secondaryBlack
        view.layer.borderWidth = 4
        addSubview(view)
        
        valueLabel.text = "43%"
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * barValueHeightFactor)
        valueLabel.textColor = UIColor.white
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        title.text = "Memory Used"
        title.font = UIFont.systemFont(ofSize: bounds.height * barTitleHeightFactor, weight: .regular)
        title.textColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1 * barPaddingFactor * bounds.height),
            valueLabel.heightAnchor.constraint(equalToConstant: bounds.height * barValueHeightFactor),
            valueLabel.widthAnchor.constraint(equalToConstant: bounds.width * barValueWidthFactor),
            
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: valueLabel.topAnchor),
            
        ])
    }
    
    func barLayout() {
        let lineWidth = bounds.height * barValueHeightFactor / 2.5
        
        let startX = bounds.width * (barValueWidthFactor + 0.025) + (lineWidth / 2)
        let startY = (bounds.height * (1 - barPaddingFactor - (barValueHeightFactor / 2))) + (lineWidth / 2)
        let endX = bounds.width - (lineWidth / 2)
        let endY = startY
        
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: startX, y: startY))
        barPath.addLine(to: CGPoint(x: endX, y: endY))
        
        shapeLayer.path = barPath.cgPath
        shapeLayer.strokeColor = gaugeColor.cgColor
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
//        layer.addSublayer(shapeLayer)
        layer.addSublayer(gradient)
    }
    
    func setBarProgress(newValue: String) {
        let barValue: Double = Double(newValue)! / 100
        shapeLayer.strokeEnd = CGFloat(barValue)
    }
}
