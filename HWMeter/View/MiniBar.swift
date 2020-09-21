//
//  miniBar.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/2/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class MiniBar: UIView {
    let title = UILabel()
    let fontSize: CGFloat = 20.0
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    var tickMarkLayer = CAShapeLayer()
    
    var constraintsList : [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    var value : CGFloat = CGFloat(0.0) {
        didSet {
            shapeLayer.strokeEnd = value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
        
        
        if GlobalConstants.isDebug {
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
            
            title.layer.borderWidth = 1
            title.layer.borderColor = UIColor.green.cgColor
            
        }
        title.text = " "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelLayout()
        barLayout()
    }
    
    func setup() {
        title.textColor = UIColor.white
        title.textAlignment = .right
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        shapeLayer.strokeColor = Theme.secondaryYellow.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        
        trackLayer.strokeColor = Theme.secondaryBlack.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        gradient.colors = Theme.barGradientColors
        gradient.locations = [0.1, 0.35, 0.65, 0.88]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.mask = shapeLayer
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(gradient)
        layer.addSublayer(tickMarkLayer)
        
        constraintsList = getConstraints()
        
    }
    
    
    
    func labelLayout() {
        title.font = UIFont.systemFont(ofSize: bounds.height * 0.4, weight: .regular)
        
//        NSLayoutConstraint.activate([
//            title.leadingAnchor.constraint(equalTo: leadingAnchor),
//            title.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * GlobalConstants.miniBarValueWidthFactor),
//            title.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
        NSLayoutConstraint.deactivate(constraintsList)
        constraintsList = getConstraints()
        NSLayoutConstraint.activate(constraintsList)
    }
    
    func getConstraints() -> [NSLayoutConstraint] {
        return [
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * GlobalConstants.miniBarValueWidthFactor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }
    
    func barLayout() {
        let lineWidth = bounds.height * GlobalConstants.barValueHeightFactor
        
        let startX = bounds.width * (GlobalConstants.miniBarValueWidthFactor) + lineWidth
        
        let startY = bounds.height / 2
        let endX = bounds.width - (lineWidth / 2) - 0.025
        let endY = startY
        
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: startX, y: startY))
        barPath.addLine(to: CGPoint(x: endX, y: endY))
        
        shapeLayer.path = barPath.cgPath
        shapeLayer.lineWidth = lineWidth
        trackLayer.path = barPath.cgPath
        trackLayer.lineWidth = lineWidth

        gradient.frame = layer.bounds

        generateTickMark(startX: startX,
                         yPosition: startY - lineWidth/2,
                         tickHeight: lineWidth)
        
        
    }
    
    func generateTickMark(startX: CGFloat, yPosition: CGFloat, tickHeight: CGFloat){
        
        let markWidth = tickHeight * 0.30
        let fullWidth = bounds.width - startX  - markWidth

        self.tickMarkLayer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        
        for item in 0...4{
            let markLayer = CAShapeLayer()
            let barPath = UIBezierPath(
                roundedRect: CGRect(x: (CGFloat(item) * fullWidth/5) + startX - (markWidth/2),
                                    y: yPosition,
                                    width: fullWidth/5,
                                    height: tickHeight),
                cornerRadius: markWidth * 0.75)
            markLayer.path = barPath.cgPath
            markLayer.strokeColor = Theme.backgroundColor.cgColor

            markLayer.lineWidth = markWidth
            
            markLayer.fillColor = UIColor.clear.cgColor
            markLayer.strokeEnd = 1
            tickMarkLayer.addSublayer(markLayer)
        }
        
    }
}

