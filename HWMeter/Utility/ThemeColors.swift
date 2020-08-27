//
//  ColorService.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    static let backgroundColor : UIColor = UIColor(red: 0.08, green: 0.08, blue: 0.17, alpha: 1.00)
    static let frontColor : UIColor = UIColor(red: 0.35, green: 0.35, blue: 0.54, alpha: 1.00)
    static let highlightColor : UIColor = UIColor(red: 0.01, green: 0.23, blue: 1.00, alpha: 1.00)
    static let supportColor: UIColor = UIColor(red: 0.00, green: 0.95, blue: 0.89, alpha: 1.00)
    
    static let gradientColors1 = [
        UIColor(red: 0.46, green: 0.09, blue: 0.97, alpha: 1.00).cgColor,
        UIColor(red: 0.89, green: 0.14, blue: 1.00, alpha: 1.00).cgColor
    ]
    static let gradientColors2 = [
        UIColor(red: 0.49, green: 0.25, blue: 1.00, alpha: 1.00).cgColor,
        UIColor(red: 0.01, green: 0.64, blue: 1.00, alpha: 1.00).cgColor,
    ]
    static let gradientColors3 = [UIColor(red: 0.30, green: 0.63, blue: 1.00, alpha: 1.00).cgColor,
                           UIColor(red: 0.30, green: 1.00, blue: 0.87, alpha: 1.00).cgColor
    ]
    
    static let secondaryYellow = UIColor(red: 1.00, green: 0.65, blue: 0.25, alpha: 1.00)
    static let secondaryGreen = UIColor(red: 0.37, green: 1.00, blue: 0.35, alpha: 1.00)
    static let secondaryRed = UIColor(red: 1.00, green: 0.18, blue: 0.18, alpha: 1.00)
    static let secondaryPurple = UIColor(red: 0.60, green: 0.11, blue: 0.98, alpha: 1.00)
    static let secondaryBirches = UIColor(red: 0.00, green: 0.95, blue: 0.89, alpha: 1.00)
    static let secondaryBlack = UIColor(red: 0.02, green: 0.02, blue: 0.06, alpha: 1.00)
}
