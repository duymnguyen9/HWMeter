//
//  GlobalConstants.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/2/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

enum GlobalConstants {
    static let isDebug = false
    static let useTestData = true
    
    static let gaugeViewHeightFactor : CGFloat = 0.6
    static let barViewHeightFactor : CGFloat = 0.25
    static let barViewSizeFactor : CGFloat = 0.90
    static let miniBarsViewHeightFactor : CGFloat = 1 - GlobalConstants.barViewHeightFactor
    static let kpiViewWidthFactor: CGFloat = 0.65
    
    static let barValueHeightFactor: CGFloat = 0.4
    static let barTitleHeightFactor: CGFloat = 0.12

    static let barValueWidthFactor: CGFloat = 0.325
    static let barPaddingFactor: CGFloat = 0.05
    
    static let miniBarValueWidthFactor: CGFloat = 0.22
    
    static let widgetTypeList : [SensorType] = [.CPU, .GPU, .GEN]
}
