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
    static let service : SensorDataService = SensorDataService()
    
    // TODO: remove this after successfully use stream instead
    var sensorData : [SensorJsonElement] = [SensorJsonElement]()
    
    let ip : String = "192.168.1.17"
    let port : String = "55555"
    
    
    let sensorDataSubject : BehaviorSubject<SensorGauge> = BehaviorSubject<SensorGauge>(value: SensorGauge())
    
    let cpuDataSubject : BehaviorSubject<SensorGauge> = BehaviorSubject<SensorGauge>(value: SensorGauge())
    let gpuDataSubject : BehaviorSubject<SensorGauge> = BehaviorSubject<SensorGauge>(value: SensorGauge())
    
    let memoryDataSubject : BehaviorSubject<SensorInfo> = BehaviorSubject<SensorInfo>(value: SensorInfo(title: "memory", value: " ", unit: "percent"))
    
    let fanDataSubject : BehaviorSubject<FanInfo> = BehaviorSubject<FanInfo>(value: FanInfo(val1: 0.0, val2: 0.0, val3: 0.0, val4: 0.0))
    
    let ipAddressSubject : BehaviorSubject<String> = BehaviorSubject<String>(value: "xxx")
    
    let useTestDataSubject : BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    

    let disposeBag = DisposeBag()
    
    func retrieveDataFromHost() {
        Observable.combineLatest(self.ipAddressSubject.asObservable(), self.useTestDataSubject.asObservable()){ (urlString, isTestData) in
                            if isTestData {
                                SensorDataService.service.readLocalFile()
                            } else {
                                SensorDataService.service.getSensorDataFromURL(urlString)
                            }
            }.observeOn(MainScheduler.init()).subscribe().disposed(by: disposeBag)
    }
    
    
    func getSensorDataFromURL(_ urlString : String) {
//        let urlString = "http://" + ip + ":" + port + "/"
//        print("urlString: \(urlString)")
        
        
                
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                sensorData = parseSensorJson(json: data)
                print("data count: \(sensorData.count)")
                
                DispatchQueue.main.async {
                    //                    self.sensorDataSubject.asObserver().onNext(SensorGauge(from: self.parseSensorJson(json: data), for: .CPU))
                    self.cpuDataSubject.asObserver().onNext(SensorGauge(from: self.parseSensorJson(json: data), for: .CPU))
                    self.gpuDataSubject.asObserver().onNext(SensorGauge(from: self.parseSensorJson(json: data), for: .GPU))
                    
                    
                    self.fanDataSubject.asObserver().onNext(FanInfo(from: self.parseSensorJson(json: data)))
                    
                    self.memoryDataSubject.asObserver().onNext(self.getMemoryInfo(from: self.parseSensorJson(json: data)))
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
                
                let cpuInfoList = [
                    SensorGauge(temp: "65", usage: 0.7, sensorType: .CPU),
                    SensorGauge(temp: "55", usage: 0.6, sensorType: .CPU),
                    SensorGauge(temp: "44", usage: 0.4, sensorType: .CPU),
                    SensorGauge(temp: "70", usage: 0.9, sensorType: .CPU),
                ]
                
                let gpuInfoList = [
                    SensorGauge(temp: "63", usage: 0.65, sensorType: .GPU),
                    SensorGauge(temp: "59", usage: 0.43, sensorType: .GPU),
                    SensorGauge(temp: "38", usage: 0.52, sensorType: .GPU),
                    SensorGauge(temp: "85", usage: 0.85, sensorType: .GPU),
                ]
                
                let memorylist = [
                    SensorInfo(title: "memory", value: "43.2", unit: "percent"),
                    SensorInfo(title: "memory", value: "67.2", unit: "percent"),
                    SensorInfo(title: "memory", value: "20.2", unit: "percent"),
                ]
                
                let fanList = [
                    FanInfo(val1: 0.65, val2: 0.43, val3: 0.52, val4: 0.5),
                    FanInfo(val1: 0.6, val2: 0.3, val3: 0.2, val4: 0.85),
                    FanInfo(val1: 0.5, val2: 0.43, val3: 0.52, val4: 0.8),
                ]
                
                self.cpuDataSubject.asObserver().onNext(cpuInfoList.randomElement()!)
                self.gpuDataSubject.asObserver().onNext(gpuInfoList.randomElement()!)
                self.memoryDataSubject.asObserver().onNext(memorylist.randomElement()!)
                self.fanDataSubject.asObserver().onNext(fanList.randomElement()!)
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
    
    func getMemoryInfo(from sensors: [SensorJsonElement]) -> SensorInfo {
        if let memoryJson = sensors.first(where: { $0.sensorName == "Physical Memory Load"})?.sensorValue {
            return SensorInfo(title: "Memory Used", value: memoryJson, unit: "%")
        } else {
            return SensorInfo(title: "Memory Used", value: "0.0", unit: "%")
        }
    }
    
    func verifyHost(_ host: String, _ portNum: String) {
        
        let urlString = "http://" + host + ":" + portNum + "/"
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                sensorData = parseSensorJson(json: data)
                if sensorData.count > 1 {
                    let urlString = "http://" + host + ":" + portNum + "/"
                    DispatchQueue.main.async {
                        self.ipAddressSubject.asObserver().onNext(urlString)
                    }
                    
                }
                
            }
        }
    }
    
    func setTestData() {
        self.useTestDataSubject.asObserver().onNext(true)
    }
}

enum ConnectionCheck {
    case fail
    case success
    case checking
}
