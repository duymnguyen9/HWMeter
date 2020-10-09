//
//  PowerInfo.swift
//  HWMeter
//
//  Created by Duy Nguyen on 10/8/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


struct PowerInfo {
    var cpuPower : CGFloat = CGFloat(50.3)
    var gpuPower : CGFloat = CGFloat(50.3)
    var motherboardPower : CGFloat = CGFloat(50.3)
    var miscPower : CGFloat = CGFloat(50.3)
    var totalPower : CGFloat = CGFloat(50.3)
    
    init(from sensorJsonList: [SensorJsonElement]) {
        var miscDiff : CGFloat = 0
        var total : CGFloat = 0
        
        if let cpuPowerJson = Float(sensorJsonList.first(where:
            { $0.sensorName == "CPU Package Power" && $0.sensorUnit == "W"})!.sensorValue)
        {
            self.cpuPower = CGFloat(cpuPowerJson)
            miscDiff -= CGFloat(cpuPowerJson)
            total += CGFloat(cpuPowerJson)
        } else {
            self.cpuPower = CGFloat(0.1)
        }
        
        if let gpuPowerJson = Float(sensorJsonList.first(where:
        { $0.sensorClass == "GPU Power" && $0.sensorUnit == "W"})!.sensorValue) {
            self.gpuPower = CGFloat(gpuPowerJson)
            total += CGFloat(gpuPowerJson)
        } else {
            self.gpuPower = CGFloat(0.1)
        }
        
        if let motherboardPowerJson = Float(sensorJsonList.first(where:
        { $0.sensorName == "Power (Input)"})!.sensorValue) {
            self.motherboardPower = CGFloat(motherboardPowerJson)
            miscDiff += CGFloat(motherboardPowerJson)
            } else {
                self.motherboardPower = CGFloat(0.1)
            }
        
        if let pcleGPUjson = Float(sensorJsonList.first(where:
        { $0.sensorName == "GPU Input PP Source Power (sum)"})!.sensorValue) {
        self.miscPower = miscDiff - CGFloat(pcleGPUjson)
            self.totalPower = self.miscPower + total
            } else {
                self.miscPower = CGFloat(0.1)
            }
        
    }
    
    init(val1: CGFloat, val2: CGFloat, val3: CGFloat, val4: CGFloat) {
        self.cpuPower = val1
        self.gpuPower = val2
        self.motherboardPower = val3
        self.miscPower = val4
        self.totalPower = val1 + val2 + val4
    }
}
