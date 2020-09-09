//
//  KPIView.swift
//  HWTest
//
//  Created by Duy Nguyen on 8/20/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class KPIView: UIView {
    var kpiViewModel: SensorInfo = SensorInfo(title: "YOUR SPEED",
                                              value: "15.24 ",
                                              unit: "MBPS") {
        didSet {
            titleLabel.text = kpiViewModel.title
            valueLabel.text = kpiViewModel.value
            unitLabel.text = kpiViewModel.unit
        }
    }
    
    let titleLabel: UILabel = UILabel()
    let valueLabel: UILabel = UILabel()
    let unitLabel: UILabel = UILabel()
    let value: CGFloat = 15

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        setUpLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpLabel() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))

        addSubview(containerView)
        
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.height * 0.3, height: bounds.height * 0.3))
        circleView.layer.cornerRadius = bounds.height * 0.1
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = Theme.secondaryYellow
        addSubview(circleView)
        
        titleLabel.text = kpiViewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.3)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.87)
        
        valueLabel.text = kpiViewModel.value
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.35)
        valueLabel.textColor = UIColor.white
        
        unitLabel.text = kpiViewModel.unit
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.35)
        unitLabel.textColor = Theme.frontColor
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            circleView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            circleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: bounds.height * 0.1),
            
            circleView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5),
            circleView.widthAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5),

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
