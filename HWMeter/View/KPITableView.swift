//
//  KPITableView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/8/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class KPITableView : UIView {
    
    var viewmodel: PowerInfo? {
        didSet {
            if let data = viewmodel {
                cpuRow.valueLabel.text = String(Int(data.cpuPower))
                gpuRow.valueLabel.text = String(Int(data.gpuPower))
                miscRow.valueLabel.text = String(Int(data.miscPower))
            }
        }
    }
    
    let stackView : UIStackView = UIStackView()
    
    var cpuRow : KPIRowView = KPIRowView(frame: .zero)
    var gpuRow : KPIRowView = KPIRowView(frame: .zero)
    var miscRow : KPIRowView = KPIRowView(frame: .zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.accessibilityIdentifier = "KPITableStack"
        addSubview(stackView)
        stackViewSetup()
        
        cpuRow.accentBar.backgroundColor = Theme.secondaryYellow
        gpuRow.accentBar.backgroundColor = Theme.highlightColor
        miscRow.accentBar.backgroundColor = Theme.secondaryGreen
        cpuRow.titleLabel.text = "CPU"
        gpuRow.titleLabel.text = "GPU"
        miscRow.titleLabel.text = "MISC"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stackViewSetup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        

        
        stackView.addArrangedSubview(cpuRow)
        stackView.addArrangedSubview(gpuRow)
        stackView.addArrangedSubview(miscRow)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
    }
}
