//
//  CpuInfo.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation


struct SensorGauge {
    var sensorTemp : String = " "
    var sensorUsage : Float = 0
    var sensorName : String = " "
    var kpi : [SensorInfo] = []
    
    init(from sensorJsonList : [SensorJsonElement], for sensorType: SensorType) {
        if sensorType == .CPU {
            if let cpuTempJson = sensorJsonList.first(where: { $0.sensorName == "CPU Package"})?.sensorValue {
                self.sensorTemp = cpuTempJson
            } else {
                self.sensorTemp = " "
            }
            
            if let cpuUsageJson = Float(sensorJsonList.first(where: { $0.sensorName == "Max CPU/Thread Usage"})!.sensorValue) {
                self.sensorUsage = cpuUsageJson / 100
            } else {
                self.sensorUsage = 0
            }
            
            self.sensorName = "CPU"
            
            var kpiList : [SensorInfo] = []
            
            if let cpuClockJson = sensorJsonList.first(where: { $0.sensorName == "Core 0 Clock (perf #1)"})?.sensorValue {
                
                let clockValue = Double(cpuClockJson)! / 1000

                kpiList.append(SensorInfo(title: "CORE CLOCK",
                                          value: String(format: "%.2f", clockValue),
                                          unit: " GHz")
                )
            }
            
            if let cpuPower = sensorJsonList.first(where: { $0.sensorName == "CPU Package Power"})?.sensorValue {
                kpiList.append(SensorInfo(title: "POWER",
                                          value: String(cpuPower.prefix(4)),
                                          unit: " W")
                )
            }
            
            
            self.kpi = kpiList
        }
        else if sensorType == .GPU{
            if let gpuTempJson = sensorJsonList.first(where: { $0.sensorName == "GPU Temperature"})?.sensorValue {
                self.sensorTemp = gpuTempJson
            } else {
                self.sensorTemp = " "
            }
            
            if let gpuUsageJson = Float(sensorJsonList.first(where: { $0.sensorName == "GPU Core Load"})!.sensorValue) {
                self.sensorUsage = gpuUsageJson / 100
            } else {
                self.sensorUsage = 0
            }
            
            self.sensorName = "GPU"
            
            var kpiList : [SensorInfo] = []
            
            if let gpuVRAMJson = sensorJsonList.first(where: { $0.sensorName == "GPU VRM Temperature"})?.sensorValue {
                
                let clockValue = Double(gpuVRAMJson)!

                kpiList.append(SensorInfo(title: "VRM TEMP",
                    value: String(String(clockValue).prefix(4)),
                                          unit: " °C")
                )
            }
            
            if let gpuPower = sensorJsonList.first(where: { $0.sensorName == "GPU Memory Usage"})?.sensorValue {
                kpiList.append(SensorInfo(title: "VRM USAGE",
                                          value: String(gpuPower.prefix(4)),
                                          unit: " %")
                )
            }
            
            
            self.kpi = kpiList
        }
    }
    
    init() {
        self.sensorTemp = " "
        self.sensorUsage = 0
    }
    
    init(temp: String, usage: Float, sensorType: SensorType) {
        self.sensorTemp = temp
        self.sensorUsage = usage
        if sensorType == .CPU {
            self.sensorName = "CPU"
            self.kpi.append(SensorInfo(title: "CPU KPI 1",
            value: "xxx",
            unit: " Unit"))
            self.kpi.append(SensorInfo(title: "CPU KPI 2",
            value: "xxx",
            unit: " Unit"))
        }
        else {
            self.sensorName = "GPU"
            self.kpi.append(SensorInfo(title: "GPU KPI 1",
            value: "xxx",
            unit: " Unit"))
            self.kpi.append(SensorInfo(title: "GPU KPI 2",
            value: "xxx",
            unit: " Unit"))
        }
    }
}

enum SensorType {
    case GPU
    case CPU
    case GEN
    case POWER
}
