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
//    let gpuView = UIView()
//    let generalView = UIView()
    
    var stackViewContraints : [NSLayoutConstraint] = [NSLayoutConstraint]()
        
    var sensorDataCheck: Disposable = {
        print("Started Timer")
        return Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .utility)).subscribe { _ in
            DispatchQueue.global(qos: .utility).async {
                if GlobalConstants.useTestData {
                    SensorDataService.sensorDataService.readLocalFile()
                } else {
                    SensorDataService.sensorDataService.getSensorDataFromURL()
                }
            }
        }
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.isIdleTimerDisabled = true
        
        view.backgroundColor = Theme.blackBackGroundColor
        view.addSubview(stackView)
        stackViewContraints = getConstraintListPortrait()
        stackView.axis = .vertical
        configureStackView()
        NSLayoutConstraint.activate(stackViewContraints)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.frame = view.safeAreaLayoutGuide.layoutFrame
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        screenOrientationLayout()
    }
    
    
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
        stackView.alignment = .fill
            
        stackView.addArrangedSubview(cpuView)
        stackView.addArrangedSubview(gpuView)
        stackView.addArrangedSubview(generalView)
        
        cpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.cpuDataSubject.asObservable())
        
        gpuView.setSensorInfoRX(observable: SensorDataService.sensorDataService.gpuDataSubject.asObservable())
        
        generalView.setMemoryDataRx(
            observable: SensorDataService.sensorDataService.memoryDataSubject.asObservable())
        generalView.setFanDataRx(
            observable: SensorDataService.sensorDataService.fanDataSubject.asObservable())
        
    }
    
    func screenOrientationLayout(){
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually

            NSLayoutConstraint.deactivate(stackViewContraints)
            
//            stackViewContraints = getConstraintListLandscape()
//            NSLayoutConstraint.activate(stackViewContraints)
        } else {
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            NSLayoutConstraint.deactivate(stackViewContraints)
            stackViewContraints = getConstraintListPortrait()
            NSLayoutConstraint.activate(stackViewContraints)
        }
    }
    
    func getConstraintListPortrait() -> [NSLayoutConstraint] {
        return [
            
            cpuView.heightAnchor.constraint(equalTo: stackView.heightAnchor,
                                            multiplier: 0.3),
            gpuView.heightAnchor.constraint(equalTo: cpuView.heightAnchor),
            generalView.heightAnchor.constraint(equalTo: stackView.heightAnchor,
            multiplier: 0.4)
        ]
    }
    
    func getConstraintListLandscape() -> [NSLayoutConstraint] {
        return [
            cpuView.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                            multiplier: 1/3),
            gpuView.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                            multiplier: 1/3),
            generalView.widthAnchor.constraint(equalTo: stackView.widthAnchor,
            multiplier: 1/3)
        ]
    }
}
