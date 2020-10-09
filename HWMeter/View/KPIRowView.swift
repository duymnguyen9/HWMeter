//
//  KPIRowView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/8/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class KPIRowView : UIView {
    
    let titleLabel: UILabel = UILabel()
    let valueLabel: UILabel = UILabel()
    let unitLabel: UILabel = UILabel()
    
    let accentBar : UIView = UIView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accentBar.backgroundColor = Theme.frontColor
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        accentBar.accessibilityIdentifier = "accentBar"
        accentBar.layer.cornerRadius = 3
        accentBar.layer.masksToBounds = true
        
        addSubview(accentBar)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(unitLabel)
        
        unitLabel.text = " W"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
        setUpLabel()
    }
    
    
    func setLayout(){
        NSLayoutConstraint.activate([
            accentBar.widthAnchor.constraint(equalToConstant: 10),
            accentBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            accentBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            accentBar.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: accentBar.centerYAnchor),
            
            
            unitLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            unitLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor),

            
            valueLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: unitLabel.leadingAnchor),
        ])
    }
    
    func setUpLabel() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.4)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.87)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.4)
        valueLabel.textColor = UIColor.white
        
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.4)
        unitLabel.textColor = Theme.frontColor
        

    }
}
