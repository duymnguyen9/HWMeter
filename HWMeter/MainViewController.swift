//
//  MainViewController.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/3/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MainViewController: UIViewController {
    let stackView = UIStackView()
    
    let sensorView: ContainerStackView = ContainerStackView(frame: .zero)
    
    let cpuView: ContainerStackView = ContainerStackView(sensorType: .CPU)
    let gpuView: ContainerStackView = ContainerStackView(sensorType: .GPU)
    let generalView: ContainerStackView = ContainerStackView(sensorType: .GEN)
    
    var initialLayout: Bool = true
    
    var sensorDataCheck: Disposable = {
        print("Started Timer")
        return Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .utility)).subscribe { _ in
            DispatchQueue.global(qos: .utility).async {
                if GlobalConstants.isDebug {
                    SensorDataService.sensorDataService.readLocalFile()
                } else {
//                    SensorDataService.sensorDataService.getSensorDataFromURL()
                    SensorDataService.sensorDataService.readLocalFile()
                }
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        view.backgroundColor = Theme.backgroundColor
        view.addSubview(stackView)
        configureStackView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if initialLayout {
            initialLayout = false
            cpuView.configureSensorWidget()
            gpuView.configureSensorWidget()
            generalView.configureSensorWidget()
        }
        
    }
    
    func configureStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
//        stackView.spacing = 10
        
        print("bounds width; \(view.bounds.width)")
        stackView.spacing = view.bounds.width / 30
        
        stackView.addArrangedSubview(cpuView)
        stackView.addArrangedSubview(gpuView)
        stackView.addArrangedSubview(generalView)
        
        cpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.cpuDataSubject.asObservable())
        
        gpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.gpuDataSubject.asObservable())
        
        generalView.setMemoryDataRx(
            observable: SensorDataService.sensorDataService.memoryDataSubject.asObservable())
        generalView.setFanDataRx(
            observable: SensorDataService.sensorDataService.fanDataSubject.asObservable())
        
        view.setNeedsLayout()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
