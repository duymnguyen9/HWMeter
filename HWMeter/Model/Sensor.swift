//
//  Sensor.swift
//  HWMeter
//
//  Created by Duy Nguyen on 8/25/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

// MARK: - SensorsJSONElement
struct SensorJsonElement: Codable {
    let sensorApp: SensorApp
    let sensorClass, sensorName, sensorValue: String
    let sensorUnit: String
    let sensorUpdateTime: Int

    enum CodingKeys: String, CodingKey {
        case sensorApp = "SensorApp"
        case sensorClass = "SensorClass"
        case sensorName = "SensorName"
        case sensorValue = "SensorValue"
        case sensorUnit = "SensorUnit"
        case sensorUpdateTime = "SensorUpdateTime"
    }
}

enum SensorApp: String, Codable {
    case hWiNFO = "HWiNFO"
}
