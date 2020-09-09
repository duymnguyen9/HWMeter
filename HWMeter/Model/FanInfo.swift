//
//  FanInfo.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/2/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct FanInfo {
    var cpuFan : CGFloat = CGFloat(50.3)
    var gpuFan : CGFloat = CGFloat(50.3)
    var exhaustFan : CGFloat = CGFloat(50.3)
    var intakeFan : CGFloat = CGFloat(50.3)
    
    init(from sensorJsonList: [SensorJsonElement]) {
        if let cpuFanJson = Float(sensorJsonList.first(where:
            { $0.sensorName == "CPU" && $0.sensorUnit == "RPM"})!.sensorValue)
        {
            self.cpuFan = CGFloat(cpuFanJson / 1900)
        } else {
            self.cpuFan = CGFloat(0.1)
        }
        
        if let gpuFanJson = Float(sensorJsonList.first(where:
        { $0.sensorClass == "GPU [#0]: NVIDIA GeForce GTX 1080: " && $0.sensorUnit == "%" && $0.sensorName == "GPU Fan"})!.sensorValue) {
            self.gpuFan = CGFloat(gpuFanJson / 100)
        } else {
            self.gpuFan = CGFloat(0.1)
        }
        
        if let exhaustFanJson = Float(sensorJsonList.first(where:
        { $0.sensorName == "System 1"})!.sensorValue) {
        self.exhaustFan = CGFloat(exhaustFanJson / 1900)
            } else {
                self.exhaustFan = CGFloat(0.1)
            }
        
        
        
        if let intakeFanJson = Float(sensorJsonList.first(where:
            {$0.sensorClass == "GPU [#0]: NVIDIA GeForce GTX 1080: ITE IT8915FN" && $0.sensorName == "GPU Fan"})!.sensorValue) {
            self.intakeFan = CGFloat(intakeFanJson / 100)
        } else {
            self.intakeFan = CGFloat(0.1)
        }
    }
    
    init(val1: CGFloat, val2: CGFloat, val3: CGFloat, val4: CGFloat) {
        self.cpuFan = val1
        self.gpuFan = val2
        self.exhaustFan = val3
        self.intakeFan = val4
    }
}

