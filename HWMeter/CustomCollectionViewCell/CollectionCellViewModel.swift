//
//  CollectionCellViewModel.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct CollectionCellViewModel {
    var sensorInfo: SensorGauge = SensorGauge(temp: "65", usage: 0.6, sensorType: .CPU)

    var gradientColor: [CGColor] = Theme.gradientColors1

    init(sensorGauge: SensorGauge) {
        if sensorGauge.sensorName == "GPU" {
            self.gradientColor = Theme.gradientColors2
            self.sensorInfo = sensorGauge
        }
        else {
            self.sensorInfo = sensorGauge
        }
    }
}
