//
//  ContainerStackView+CPU.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/6/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

// Gauge Configuration
extension ContainerStackView {
    
    func gaugeKPIViewLayout() {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .vertical
            NSLayoutConstraint.deactivate(gaugeViewConstraints)
            gaugeViewConstraints = getGaugeConstraintsLandscape()
            NSLayoutConstraint.activate(gaugeViewConstraints)
        } else {
            stackView.axis = .horizontal
            
            NSLayoutConstraint.deactivate(gaugeViewConstraints)
            gaugeViewConstraints = getGaugeConstraintPortrait()
            NSLayoutConstraint.activate(gaugeViewConstraints)
        }
    }
    
    func getGaugeConstraintsLandscape() -> [NSLayoutConstraint] {
        return [
            gaugeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            gaugeView.widthAnchor.constraint(equalTo: widthAnchor),
            kpiStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: GlobalConstants.kpiViewWidthFactor),
            kpiStackView.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: (0.95 - GlobalConstants.gaugeViewHeightFactor)),

        ]
    }
    
    func getGaugeConstraintPortrait() -> [NSLayoutConstraint] {
        return [
            gaugeView.heightAnchor.constraint(equalTo: heightAnchor),
            gaugeView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: GlobalConstants.gaugeViewHeightFactor),
            kpiStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            kpiStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                multiplier: GlobalConstants.kpiViewWidthFactor),
            
        ]
    }
    
}
