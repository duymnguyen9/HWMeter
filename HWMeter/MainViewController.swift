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

class MainViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    let stackView = UIStackView()
    
    let sensorView: ContainerStackView = ContainerStackView(frame: .zero)
    
    let cpuView: ContainerStackView = ContainerStackView(sensorType: .CPU)
    let gpuView: ContainerStackView = ContainerStackView(sensorType: .GPU)
    let generalView: ContainerStackView = ContainerStackView(sensorType: .GEN)

    var stackViewContraints : [NSLayoutConstraint] = [NSLayoutConstraint]()
        
    var sensorDataCheck: Disposable = {
        print("Started Timer")
        return Observable<Int>.interval(.seconds(2), scheduler: SerialDispatchQueueScheduler(qos: .utility)).subscribe { _ in
            DispatchQueue.global(qos: .utility).async {      
                SensorDataService.service.retrieveDataFromHost()
            }
        }
    }()
    
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.isIdleTimerDisabled = true
        
        cpuView.accessibilityIdentifier = "CPU_View"
        gpuView.accessibilityIdentifier = "GPU_View"
        generalView.accessibilityIdentifier = "GEN_View"
        stackView.accessibilityIdentifier = "Main_StackView"

        
        view.backgroundColor = Theme.blackBackGroundColor
        view.addSubview(stackView)
        configureStackView()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.frame = view.safeAreaLayoutGuide.layoutFrame
        layoutWhenRotate()

    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        screenOrientationLayout()
    }
    
    
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
            
        stackView.addArrangedSubview(cpuView)
        stackView.addArrangedSubview(gpuView)
        stackView.addArrangedSubview(generalView)
        
        stackViewContraints = getConstraintListPortrait()
        NSLayoutConstraint.activate(stackViewContraints)

        
        cpuView.setSensorInfoRX(observable: SensorDataService.service.cpuDataSubject.asObservable())
        
        gpuView.setSensorInfoRX(observable: SensorDataService.service.gpuDataSubject.asObservable())
        
        generalView.setMemoryDataRx(
            observable: SensorDataService.service.memoryDataSubject.asObservable())
        generalView.setFanDataRx(
            observable: SensorDataService.service.fanDataSubject.asObservable())
        
    }
    
    func screenOrientationLayout(){
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .fill

            NSLayoutConstraint.deactivate(stackViewContraints)
            
        } else {
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing

        }
    }
    
    func getConstraintListPortrait() -> [NSLayoutConstraint] {
        return [
            
            cpuView.heightAnchor.constraint(equalTo: stackView.heightAnchor,
                                            multiplier: 0.28),
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
    
    func layoutWhenRotate() {
        if UIDevice.current.orientation.isPortrait && stackView.bounds.height >= stackView.bounds.width {
            NSLayoutConstraint.deactivate(stackViewContraints)
            stackViewContraints = getConstraintListPortrait()
            NSLayoutConstraint.activate(stackViewContraints)
        }
    }

}
