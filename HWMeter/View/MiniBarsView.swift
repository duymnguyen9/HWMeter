//
//  MiniBarsView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/1/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit


class MiniBarsView: UIView {
    
    let title = UILabel()
    
    var miniBarViewModel : FanInfo = FanInfo(val1: 0.1, val2: 0.1, val3: 0.1, val4: 0.1) {
        didSet {
            cpuFan.value = miniBarViewModel.cpuFan
            gpuFan.value = miniBarViewModel.gpuFan
            exhaustFan.value = miniBarViewModel.exhaustFan
            intakeFan.value = miniBarViewModel.intakeFan
        }
    }
    let stackView = UIStackView()
    
    let cpuFan : MiniBar = MiniBar(frame: .zero)
    let gpuFan : MiniBar = MiniBar(frame: .zero)
    let exhaustFan : MiniBar = MiniBar(frame: .zero)
    let intakeFan : MiniBar = MiniBar(frame: .zero)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        if GlobalConstants.isDebug {
            layer.borderWidth = 1
            layer.borderColor = UIColor.blue.cgColor
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.font = UIFont.systemFont(ofSize: bounds.width * GlobalConstants.barTitleHeightFactor, weight: .regular)
    }
    
    func setup() {
        
        title.text = "Fan Speed"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.white
        
        
        cpuFan.translatesAutoresizingMaskIntoConstraints = false
        gpuFan.translatesAutoresizingMaskIntoConstraints = false
        exhaustFan.translatesAutoresizingMaskIntoConstraints = false
        intakeFan.translatesAutoresizingMaskIntoConstraints = false
        
        cpuFan.title.text = "CPU"
        gpuFan.title.text = "GPU"
        exhaustFan.title.text = "EXH"
        intakeFan.title.text = "INT"

        
        if GlobalConstants.isDebug{
            cpuFan.layer.borderWidth = 1
            cpuFan.layer.borderColor = UIColor.red.cgColor
        }
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        stackView.addArrangedSubview(cpuFan)
        stackView.addArrangedSubview(gpuFan)
        stackView.addArrangedSubview(exhaustFan)
        stackView.addArrangedSubview(intakeFan)
        addSubview(title)
        addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint( equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint( equalTo: trailingAnchor),
        ])
        
    }
}
