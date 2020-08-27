//
//  CpuInfo.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation


struct SensorGauge {
    var cpuTemp : String = "~"
    var cpuUsage : Float = 0
    
    init(from sensorJsonList : [SensorJsonElement]) {
        if let cpuTempJson = sensorJsonList.first(where: { $0.sensorName == "CPU Package"})?.sensorValue {
            self.cpuTemp = cpuTempJson
        } else {
            self.cpuTemp = "~"
        }
        
        if let cpuUsageJson = Float(sensorJsonList.first(where: { $0.sensorName == "Core 0 Usage"})!.sensorValue) {
            self.cpuUsage = cpuUsageJson / 100
        } else {
            self.cpuUsage = 0
        }
    }
    
    init() {
        self.cpuTemp = "~"
        self.cpuUsage = 0
    }
    
    init(temp: String, usage: Float) {
        self.cpuTemp = temp
        self.cpuUsage = usage
    }
}

struct GPUInfo {
    
}
