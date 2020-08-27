//
//  KPIView.swift
//  HWTest
//
//  Created by Duy Nguyen on 8/20/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


class KPIView: UIView {
    var kpiViewModel : SensorInfo = SensorInfo(title: "YOUR SPEED",
                                                   value: "15.24 ",
                                                   unit: "MBPS") {
        didSet {
            titleLabel.text = kpiViewModel.title
            valueLabel.text = kpiViewModel.value
            unitLabel.text = kpiViewModel.unit
        }
    }
    
    
    
    
    let titleLabel : UILabel = UILabel()
    let valueLabel : UILabel = UILabel()
    let unitLabel: UILabel = UILabel()
    let value : CGFloat = 15

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func setUpLabel(){
                
//        let containerView = UIView(frame: CGRect(x: bounds.width * 1 / 8, y: bounds.width * 1 / 8, width: bounds.width * 6 / 8, height: bounds.width  * 2.5 / 8))
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))

//        containerView.backgroundColor = UIColor.yellow
        addSubview(containerView)
        
        
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width / 16, height: bounds.width / 16))
        circleView.layer.cornerRadius = bounds.width / 50
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = UIColor.red
        addSubview(circleView)
        
        titleLabel.text = kpiViewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: bounds.width / 14)
        titleLabel.textColor = UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
        
        valueLabel.text = kpiViewModel.value
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.width / 9)
        valueLabel.textColor = UIColor.white
        
        unitLabel.text = kpiViewModel.unit
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.systemFont(ofSize: bounds.width / 9)
        unitLabel.textColor =  UIColor(red: 0.50, green: 0.51, blue: 0.52, alpha: 1.00)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(unitLabel)
        
//        layer.borderWidth = 3
//        layer.borderColor = Theme.secondaryGreen.cgColor
        
        NSLayoutConstraint.activate([
            
            
            circleView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            circleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: bounds.width / 50),
            
            circleView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5),
            circleView.widthAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5),
            
//            circleView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant:  bounds.width / 16 ),
//            circleView.rightAnchor.constraint(equalTo: containerView.leftAnchor, constant: bounds.width / 16),
//            circleView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 1),
//            circleView.widthAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5),
            
            titleLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: bounds.width / 50),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            unitLabel.leftAnchor.constraint(equalTo: valueLabel.rightAnchor),
            unitLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            
                        
//            containerView.leftAnchor.constraint(equalTo: leftAnchor),
//            containerView.rightAnchor.constraint(equalTo: rightAnchor),
//            containerView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
