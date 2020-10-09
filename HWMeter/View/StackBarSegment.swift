//
//  StackBarSegment.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/6/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class StackBarSegment : UIView {
    let segmentShape : CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func deactivateWidth() {
        for constraint in constraints {
            guard constraint.firstAnchor == widthAnchor else { continue }
            constraint.isActive = false

        }
    }

}
