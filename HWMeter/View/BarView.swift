//
//  BarView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/1/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit



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
    var barViewModel: BarViewModel = BarViewModel(sensorInfo: SensorInfo(title: " ", value: " ", unit: " ")) {
        didSet {
            if barViewModel.value == " " {
                print("value is empty")
                title.text = " "
                unitLabel.text = " "
            }
            else {
                title.text = "Memory Used"
                unitLabel.text = "%"
                let numberInString: String = String(barViewModel.value.prefix(2))
                valueLabel.text = numberInString
                setBarProgress(newValue: barViewModel.value)
            }
            

        }
    }
    
    let valueLabel = UILabel()
    let title = UILabel()
    let unitLabel = UILabel()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    let trackColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
    let gaugeColor = UIColor.black
    var gradientColors = Theme.gradientColors3
    var constraintsList : [NSLayoutConstraint] = [NSLayoutConstraint]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        valueLabel.text = " "
        shapeLayer.strokeEnd = 0
        constraintsList = getConstraintList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    
    func setup() {
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * GlobalConstants.barValueHeightFactor)
        valueLabel.textColor = UIColor.white
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        

        title.font = UIFont.systemFont(ofSize: bounds.width * GlobalConstants.barTitleHeightFactor, weight: .regular)
        title.textColor = UIColor.white.withAlphaComponent(0.87)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        unitLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * GlobalConstants.barValueHeightFactor * 0.6)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.textColor = UIColor.white
        
        addSubview(title)
        addSubview(valueLabel)
        addSubview(unitLabel)
        
        barLayout()
        labelLayout()
        
    }
    
    func barLayout() {
        let lineWidth = bounds.height * GlobalConstants.barValueHeightFactor / 2.5
        
        let startX = bounds.width * (GlobalConstants.barValueWidthFactor + 0.025)
        
        let startY = bounds.height * (1 - GlobalConstants.barPaddingFactor - (GlobalConstants.barValueHeightFactor / 2))
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
        
        trackLayer.path = barPath.cgPath
        trackLayer.strokeColor = Theme.secondaryBlack.cgColor
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
        layer.addSublayer(gradient)
        
        
        
        
        
        if GlobalConstants.isDebug {
            layer.borderWidth = 1
            layer.borderColor = UIColor.green.cgColor
        }
    }

    
    func setBarProgress(newValue: String) {
        let barValue: Double = Double(newValue)! / 100
        shapeLayer.strokeEnd = CGFloat(barValue)
    }
    
    func labelLayout() {
//        NSLayoutConstraint.activate([
//            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
//                                               constant: -1 * GlobalConstants.barPaddingFactor * bounds.height),
//
//            title.leadingAnchor.constraint(equalTo: leadingAnchor),
//            title.trailingAnchor.constraint(equalTo: trailingAnchor),
//            title.bottomAnchor.constraint(equalTo: valueLabel.topAnchor),
//
//            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor,
//                                           constant: GlobalConstants.barPaddingFactor * bounds.height),
//            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor,
//                                               constant: GlobalConstants.barPaddingFactor * bounds.height)
//
//        ])
        NSLayoutConstraint.deactivate(constraintsList)
        constraintsList = getConstraintList()
        NSLayoutConstraint.activate(constraintsList)
    }
    
    func getConstraintList() -> [NSLayoutConstraint]{
        return [
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -1 * GlobalConstants.barPaddingFactor * bounds.height),
            
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: valueLabel.topAnchor),
            
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor,
                                           constant: GlobalConstants.barPaddingFactor * bounds.height),
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor,
                                               constant: GlobalConstants.barPaddingFactor * bounds.height)
            
        ]
    }
}
