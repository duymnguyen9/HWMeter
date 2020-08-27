//
//  SensorDataService.swift
//  HWTest
//
//  Created by Duy Nguyen on 8/20/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class SensorDataService {
    
    // TODO: remove this after successfully use stream instead
    var sensorData : [SensorJsonElement] = [SensorJsonElement]()
    
    static let sensorDataService : SensorDataService = SensorDataService()
    let ip : String = "192.168.1.17"
    let port : String = "55555"
    
    let sensorDataSubject : BehaviorSubject<CPUInfo> = BehaviorSubject<CPUInfo>(value: CPUInfo())
    
    func getSensorDataFromURL() {
        let urlString = "http://" + ip + ":" + port + "/"
        print("urlString: \(urlString)")
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                sensorData = parseSensorJson(json: data)
                print("data count: \(sensorData.count)")
                
                DispatchQueue.main.async {
                    self.sensorDataSubject.asObserver().onNext(CPUInfo(from: self.parseSensorJson(json: data)))
                }
            }
        }
    }
    
    func readLocalFile() {
        guard let mainurl = Bundle.main.url(forResource: "hwmonitor", withExtension: "json") else {
            print("mainUrl was not available")
            return
        }
        do {
            let data = try Data(contentsOf: mainurl)
            sensorData = parseSensorJson(json: data)
            DispatchQueue.main.async {
                self.sensorDataSubject.asObserver().onNext(CPUInfo(from: self.parseSensorJson(json: data)))
            }
            
        } catch {
            print(error)
        }
    }
    
    
    func parseSensorJson(json: Data) -> [SensorJsonElement]{
        let decoder = JSONDecoder()
        
        if let sensorJsonList = try?
            decoder.decode([SensorJsonElement].self, from: json){
//            print("done decoding")
            return sensorJsonList
        } else {
            print("fail decoding")
            return []
        }
    }
    
    func getCpuInfo() -> CPUInfo {
        return CPUInfo(from: self.sensorData)
    }
}
