//
//  ContainerStackView+GEN.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/6/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension ContainerStackView {
    
    func generalViewLayout(){
        if UIDevice.current.orientation.isLandscape {
            
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(generalViewConstraints)
            generalViewConstraints = getGeneralViewConstraintsLandscape()
            NSLayoutConstraint.activate(generalViewConstraints)
        } else {
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(generalViewConstraints)
            generalViewConstraints = getGeneralViewConstraintsPortrait()
            NSLayoutConstraint.activate(generalViewConstraints)
        }
        
    }
    
    func getGeneralViewConstraintsLandscape() -> [NSLayoutConstraint]{
        return [
//            containerView.leftAnchor.constraint(equalTo: leftAnchor),
//            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.95),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            memoryView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: GlobalConstants.barViewHeightFactor),
            memoryView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            fanView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.9 - GlobalConstants.barViewHeightFactor),
            fanView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
    func getGeneralViewConstraintsPortrait() -> [NSLayoutConstraint]{
        let portraitBarViewHeightFactor = GlobalConstants.barViewHeightFactor + 0.1
        
        return [
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.95),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            memoryView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                               multiplier: portraitBarViewHeightFactor),
            memoryView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
            fanView.heightAnchor.constraint(equalTo: containerView.heightAnchor,
                                            multiplier: 0.95 - portraitBarViewHeightFactor),
            fanView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: paddingFactor),
        ]
    }
    
}
