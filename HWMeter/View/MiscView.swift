//
//  MiscView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/26/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit


struct BarViewModel {
    let title : String = "XXXXXX"
    let value : String = "XXXXXX"
    let unit : String = "XXXXXX"
}

class BarView: UIView {
    var barViewModel : BarViewModel = BarViewModel()
    
    static let barWidthFactor : CGFloat = 0.55
    static let barHeightFactor : CGFloat = 0.25
    
    // MARK: - Properties
    let shapeLayer = CAShapeLayer()
    let valueLabel = UILabel()
    let title = UILabel()
    let gradient = CAGradientLayer()
    
    let valueLabelColor = UIColor.white
    let titleColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
    let subtitleColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
    let trackColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
    let gaugeColor = UIColor.black
    
    //    let shapeView : UIView = UIView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        barSetup()
        setup()
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        barSetup()
//        setup()
    }
    
    func setup(){
        valueLabel.text = "43%"
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.12)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textColor = valueLabelColor
        
        title.text = "Memory Used"
        title.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.1)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = titleColor
        
        addSubview(title)
        addSubview(valueLabel)
        
        layer.addSublayer(shapeLayer)
        
        NSLayoutConstraint.activate([
                        valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                        valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            //            valueLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            
            
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
//            title.topAnchor.constraint(equalTo: topAnchor),

                
            

        ])
        
    }
    
    func barSetup(){
        print("barSetup")
        print(bounds.width)
        var size = CGSize()
        do {
            try size = LayoutConfig.sharedConfig.cellSize.value()
            print(size)
        } catch {
            print(error)
        }
        
        let xPosition = bounds.width * (0.95 - BarView.barWidthFactor)
        let yPosition = bounds.height * (0.9 - BarView.barHeightFactor)
        
        shapeLayer.path = UIBezierPath(
            roundedRect: CGRect(x: xPosition,
                                y: yPosition,
                                width: bounds.width * BarView.barWidthFactor,
                                height: bounds.height * BarView.barHeightFactor), cornerRadius: bounds.height * BarView.barHeightFactor / 2).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        //        addSubview(shapeView)
    }
}

