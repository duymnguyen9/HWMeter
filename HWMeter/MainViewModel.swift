//
//  MainViewModel.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/7/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ContainerStackViewModel {
    var sensorInfo: Observable<SensorGauge>?
    
    var memoryInfo: Observable<SensorInfo>?
    
    var fanInfo: Observable<FanInfo>?
}
