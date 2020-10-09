//
//  ContainerStackView+POWER.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/6/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


extension ContainerStackView {
    
    func powerViewLayout() {
        stackView.axis = .vertical
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(powerViewConstraints)
            powerViewConstraints = getPowerViewConstraintsLandscape()
            NSLayoutConstraint.activate(powerViewConstraints)
        } else {
            NSLayoutConstraint.deactivate(powerViewConstraints)
            powerViewConstraints = getPowerViewConstraintsPortrait()
            NSLayoutConstraint.activate(powerViewConstraints)
        }
        
    }
    
    func getPowerViewConstraintsLandscape() -> [NSLayoutConstraint]{
        return [
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: paddingFactor ),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            totalPowerView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: GlobalConstants.barViewHeightFactor),
            totalPowerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            powerKPIView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.9 - GlobalConstants.barViewHeightFactor),
            powerKPIView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
    func getPowerViewConstraintsPortrait() -> [NSLayoutConstraint]{
        let portraitBarViewHeightFactor = GlobalConstants.barViewHeightFactor + 0.1
        
        return [
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.95),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            totalPowerView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: portraitBarViewHeightFactor),
            totalPowerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            powerKPIView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.95 - portraitBarViewHeightFactor),
            powerKPIView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
}
