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
//            print(miniBarViewModel)
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
        if GlobalConstants.isDebug {
            layer.borderWidth = 1
            layer.borderColor = UIColor.blue.cgColor
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

    }
    
    func setup() {
        
        title.text = "Fan Speed (%)"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: bounds.width * GlobalConstants.barTitleHeightFactor, weight: .regular)
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
        
//        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(cpuFan)
        stackView.addArrangedSubview(gpuFan)
        stackView.addArrangedSubview(exhaustFan)
        stackView.addArrangedSubview(intakeFan)
        addSubview(title)
        addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 4),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint( equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint( equalTo: trailingAnchor),
        ])
        
        layoutIfNeeded()
        
        cpuFan.setup(barColor: Theme.secondaryBirches)
        gpuFan.setup(barColor: Theme.secondaryYellow)
        exhaustFan.setup(barColor: Theme.secondaryPurple)
        intakeFan.setup(barColor: Theme.secondaryGreen)
    }
    
    func labelLayout() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: topAnchor,
                                          constant: bounds.height / 5),
            
            cpuFan.leadingAnchor.constraint(equalTo: leadingAnchor),
            cpuFan.trailingAnchor.constraint(equalTo: trailingAnchor),
            cpuFan.topAnchor.constraint(equalTo: title.bottomAnchor),
            cpuFan.bottomAnchor.constraint(equalTo: cpuFan.topAnchor,
                                           constant: bounds.height / 5),
            
            gpuFan.leadingAnchor.constraint(equalTo: leadingAnchor),
            gpuFan.trailingAnchor.constraint(equalTo: trailingAnchor),
            gpuFan.topAnchor.constraint(equalTo: cpuFan.bottomAnchor),
            gpuFan.bottomAnchor.constraint(equalTo: gpuFan.topAnchor,
                                           constant: bounds.height / 5),
            
            exhaustFan.leadingAnchor.constraint(equalTo: leadingAnchor),
            exhaustFan.trailingAnchor.constraint(equalTo: trailingAnchor),
            exhaustFan.topAnchor.constraint(equalTo: gpuFan.bottomAnchor),
            exhaustFan.bottomAnchor.constraint(equalTo: exhaustFan.topAnchor,
                                           constant: bounds.height / 5),
            
            intakeFan.leadingAnchor.constraint(equalTo: leadingAnchor),
            intakeFan.trailingAnchor.constraint(equalTo: trailingAnchor),
            intakeFan.topAnchor.constraint(equalTo: exhaustFan.bottomAnchor),
            intakeFan.bottomAnchor.constraint(equalTo: intakeFan.topAnchor,
                                           constant: bounds.height / 5),
        ])
    }
    
}
