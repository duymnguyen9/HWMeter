//
//  MiniBarsView.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/1/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


class MiniBarsView: UIView {
    
    let title = UILabel()
    
    var miniBarViewModel : FanInfo = FanInfo(val1: 0.1, val2: 0.1, val3: 0.1, val4: 0.1) {
        didSet {
            if miniBarViewModel.cpuFan == 0.0 {
                title.text = " "
                cpuFan.title.text = " "
                gpuFan.title.text = " "
                exhaustFan.title.text = " "
                intakeFan.title.text = " "
                cpuFan.value = 0.0
                gpuFan.value = 0.0
                exhaustFan.value = 0.0
                intakeFan.value = 0.0
            } else {
                cpuFan.value = miniBarViewModel.cpuFan
                gpuFan.value = miniBarViewModel.gpuFan
                exhaustFan.value = miniBarViewModel.exhaustFan
                intakeFan.value = miniBarViewModel.intakeFan
                title.text = "Fan Speed"
                cpuFan.title.text = "CPU"
                gpuFan.title.text = "GPU"
                exhaustFan.title.text = "EXH"
                intakeFan.title.text = "INT"
            }
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
        title.textColor = UIColor.white.withAlphaComponent(0.87)
    }
    
    func setup() {
        
        title.translatesAutoresizingMaskIntoConstraints = false        
        
        cpuFan.translatesAutoresizingMaskIntoConstraints = false
        gpuFan.translatesAutoresizingMaskIntoConstraints = false
        exhaustFan.translatesAutoresizingMaskIntoConstraints = false
        intakeFan.translatesAutoresizingMaskIntoConstraints = false
        


        
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
