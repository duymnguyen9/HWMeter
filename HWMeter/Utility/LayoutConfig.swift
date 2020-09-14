//
//  LayoutConfig.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/10/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LayoutConfig {
    static let sharedConfig : LayoutConfig = LayoutConfig()
    
    let isLandscapeSubject : BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
}
