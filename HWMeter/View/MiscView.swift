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

        barSetup()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        barSetup()
        setup()
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
        
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width * 0.55, height: bounds.width * 0.1))
        bar.layer.addSublayer(shapeLayer)
        addSubview(bar)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width / 50),
             valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -0.05 * bounds.width),
             valueLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            
            bar.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            bar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bar.topAnchor.constraint(equalTo: valueLabel.topAnchor)
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
        
        
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width * 0.55, height: bounds.width * 0.1), cornerRadius: 50).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
//        addSubview(shapeView)
    }
}

