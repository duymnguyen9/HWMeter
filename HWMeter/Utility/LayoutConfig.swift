//
//  LayoutConfig.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LayoutConfig {
    static let sharedConfig = LayoutConfig()
    
    let cellSize : BehaviorSubject<CGSize> = BehaviorSubject(value: CGSize(width: 100, height: 100))
    
}
